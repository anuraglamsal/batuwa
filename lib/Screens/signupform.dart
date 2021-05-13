import 'package:flutter/material.dart'; 
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../Cloud/cloud.dart';
import 'package:lottie/lottie.dart';

class signupform extends StatefulWidget{//Needs to be stateful to show errors.
  @override
  _signupformState createState() => _signupformState();
}

class _signupformState extends State<signupform>{
  bool validated = false;
  bool email_exists = false;
  bool successful = false;
  TextEditingController emailController = TextEditingController(); 
  TextEditingController passwordController = TextEditingController(); 
  GlobalKey<FormState> formkey = GlobalKey<FormState>(); //Formkey is required for validators to work.
  Color labelcolor1 = Color(0xff000000);
  Color labelcolor2 = Color(0xff000000);
  var onpressed = null;
  AutovalidateMode _autovalidatemode = AutovalidateMode.disabled;

  @override
  void initState(){
    super.initState();
    emailController.addListener(change_disable_or_enable);
    passwordController.addListener(change_disable_or_enable);
  }

  change_disable_or_enable(){
    if(emailController.text != "" && passwordController.text != ""){
      setState((){
	onpressed = (){
	  if(formkey.currentState.validate()){
	    setState((){
	      successful = true;
	      validated = false;
	      email_exists = false;
	      _autovalidatemode = AutovalidateMode.disabled;
	    });
	    registerNewUser(emailController.text, passwordController.text);
   	  }
	  else{
	    setState((){
	      _autovalidatemode = AutovalidateMode.onUserInteraction;
	    });
	  }
	};
      });
    }
    else{
      setState((){
	onpressed = null;
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Form(
	key: formkey, 
	autovalidateMode: _autovalidatemode,
	child: Container(
	  alignment: Alignment.center, 
	  color: Color(0xffffffff),
	  child: Column(
	    mainAxisAlignment: MainAxisAlignment.start, 
	    children: <Widget>[
	      SizedBox(height: 33),
	      Focus(
		onFocusChange: (hasFocus){
		  setState((){
		    labelcolor1 = hasFocus ? Color(0xff07B0B5) : Color(0xff000000);
		  });
		},
		child: Container(
		  width: 300,
		  child: TextFormField(
		    controller: emailController,
		    style: TextStyle(color: Colors.black,),
		    decoration: InputDecoration(
		      filled: true,
		      fillColor: Color(0xfff2f2f2),
		      labelText: "Email",
		      labelStyle: TextStyle(
			color: labelcolor1,
		      ),
		      contentPadding: EdgeInsets.fromLTRB(13, 32, 32, 0),
		      border: OutlineInputBorder(),
		      focusedBorder: OutlineInputBorder(
			borderSide: BorderSide(color: Color(0xff07B0B5), width: 2.0,),
		      ),
		    ),
		    cursorColor: Colors.blueGrey,
		    validator: (value){ 
		      if(value.isEmpty){ 
			remove_errors_from_screen();
			return "Required";
		      }
		      else{
			if(!EmailValidator.validate(value)){
			  remove_errors_from_screen();
			  return "Not a valid email";
			}
		      }
		    },
		  ),
		),
	      ),
	      SizedBox(height: 20),
	      Focus(
		onFocusChange: (hasFocus){
		  setState((){
		    labelcolor2 = hasFocus ? Color(0xff07B0B5) : Color(0xff000000);
		  });
		},
		child: Container(
		  width: 300,
		  child: TextFormField(
		    controller: passwordController, 
		    style: TextStyle(color: Colors.black),
		    decoration: InputDecoration(
		      filled: true,
		      fillColor: Color(0xfff2f2f2),
		      errorMaxLines: 3,
		      labelText: "Password",
		      labelStyle: TextStyle(
			color: labelcolor2,
		      ),
		      contentPadding: EdgeInsets.fromLTRB(13, 32, 32, 0),
		      border: OutlineInputBorder(),
		      focusedBorder: OutlineInputBorder(
			borderSide: BorderSide(color: Color(0xff07B0B5), width: 2.0,),
		      ),
		    ),
		    cursorColor: Colors.blueGrey,
		    validator: (value){ 
		      if(value.isEmpty){
			remove_errors_from_screen();
			return "Required";
		      }
		      else if(value.length<12){
			remove_errors_from_screen();
			return "A password of length more than or equal to 12 is required";
		      }
		      else if(!verifyPasswordRules(value)){
			remove_errors_from_screen();
			return "Password should be a combination of at least one of each of uppercase and lowercase letters, digits and special characters (! @ # \$ & * ~ ).";
		      }
		    },
		    obscureText: true 
		  ),
		),
	      ),
	      SizedBox(height: 20),
	      successful ?
		  CircularProgressIndicator(
		    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff07B0B5)),
		  ) :
		  Container(
		    height: 42, 
		    width: 300,
		    child: ElevatedButton(
		      onPressed: onpressed,
		      child: Text("SIGN UP",),
		      style: ButtonStyle(
			backgroundColor:MaterialStateProperty.resolveWith<Color>(
			  (Set<MaterialState> states) {
			    if (states.contains(MaterialState.pressed))
			      return Color(0xff07B0B5); //On pressed color
			    else if (states.contains(MaterialState.disabled))
			      return Color.fromRGBO(7, 176, 181, 0.2); //Disabled color
			    return Color(0xff07B0B5); //Enabled color
			  },
			), 
		      ),
		    ),
		  ),
	      SizedBox(height:20),
	      validated ? Text("Successful! Please verify your email address, which is a one time process, by going to your email inbox.",
	                style: TextStyle(fontSize:17, color: Colors.blue[100], fontFamily: 'Mohave',), textAlign: TextAlign.center,):SizedBox(),
	      email_exists ? Text("User with that e-mail already exists",
		           style: TextStyle(fontSize:17, color: Colors.red[500], fontFamily: 'Mohave',), textAlign: TextAlign.center,):SizedBox(),
            ]
	  )
	)
      ),
    );
  }

  bool verifyPasswordRules(String value){ 
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  remove_errors_from_screen(){
    validated = false;
    email_exists = false;
    successful = false;
  }

  FirebaseAuth auth = FirebaseAuth.instance; 

  registerNewUser(email, password) async{
    bool flag = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword( //Read the flutter firebase auth docs to understand this
	email: email, 
	password: password  
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
	flag = false;
	setState((){
	  validated = false;
	  successful = false;
	  email_exists = true;
	});
      }
    }
    if(flag == true){
      auth.currentUser.sendEmailVerification();
      firsttimelogin(1);
      await auth.signOut(); //Need to do this because users persist in sign up too. Thus, if the app is restarted, the user's account is opened,
      //and not the home screen.
      setState((){
	email_exists = false;
	validated = true;
	successful = false;
      });
    }
  }

}
