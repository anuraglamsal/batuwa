import 'package:flutter/material.dart'; 
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class signupform extends StatefulWidget{//Needs to be stateful to show errors.
  @override
  _signupformState createState() => _signupformState();
}

class _signupformState extends State<signupform>{
  GlobalKey<FormState> formkey = GlobalKey<FormState>(); //Formkey is required for validators to work.
  bool validated = false;
  bool email_exists = false;
  bool successful = false;
  TextEditingController emailController = new TextEditingController(); 
  TextEditingController passwordController = new TextEditingController(); 
  @override
  Widget build(BuildContext context){
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible){
	return Form(
	  key: formkey, 
	  child: Container(
	    alignment: Alignment.center, 
	    color: Color(0xff0e0f26),
	    child: Column(
	      mainAxisAlignment: MainAxisAlignment.start, 
	      children: <Widget>[
		SizedBox(height: 10),
		!isKeyboardVisible ? 
		Image.asset('assets/images/logo.png', width: 300, height: 150):SizedBox(),
		Container(
		  height: 58,
		  width: 350,
		  alignment: Alignment.center,
		  decoration: BoxDecoration(
		    color: Color(0xff2c334f),
		    borderRadius: BorderRadius.all(Radius.circular(15)),
		  ),
		  child: Text(
		    "Create your account here",
		    style: TextStyle(fontSize: 28, color: Colors.white, fontFamily: 'Mohave',),
		  ),
		),
		SizedBox(height: 17),
		Container(
		  alignment: Alignment.center,
		  height: 50,
		  width: 330,
		  decoration: BoxDecoration(
		    color: Color(0xff252a42),
		    borderRadius: BorderRadius.all(Radius.circular(20)),
		  ),
		  child: Text(
		    "E-mail",
		    style: TextStyle(fontSize: 19.5, color: Colors.white, fontFamily: 'Mohave'),
		  )
		),                                                            
		SizedBox(height:5),
		Container(
		  width: 330,
		  child:TextFormField(
		    controller: emailController,
		    style: TextStyle(color: Colors.white),
		    decoration: InputDecoration(
		      enabledBorder: UnderlineInputBorder(
			borderSide: BorderSide(color: Color(0xff434a66)),
		      ),
		      focusedBorder: UnderlineInputBorder(
			borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),	
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
		SizedBox(height: 15),
		Container(
		  alignment: Alignment.center,
		  height: 50,
		  width: 330,
		  decoration: BoxDecoration(
		    color: Color(0xff252a42),
		    borderRadius: BorderRadius.all(Radius.circular(20)),
		  ),
		  child: Text(
		    "Password",
		    style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Mohave'),
		  )
		),
		SizedBox(height: 5),
		Container(
		  width: 330,
		  child: TextFormField(
		    controller: passwordController, 
		    style: TextStyle(color: Colors.white),
		    decoration: InputDecoration(
		      errorMaxLines: 3,
		      enabledBorder: UnderlineInputBorder(
			borderSide: BorderSide(color: Color(0xff434a66)),
		      ),
		      focusedBorder: UnderlineInputBorder(
			borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),	
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
		      else if(!validateStructure(value)){
			remove_errors_from_screen();
			return "Password should be a combination of at least one of each of uppercase and lowercase letters, digits and special characters (! @ # \$ & * ~ ).";
		      }
		    },
		    obscureText: true 
		  ),
		),
		SizedBox(height: 15),
		successful ?
		    CircularProgressIndicator(
		      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
		    ) :
		    Container(
		      height: 42, 
		      child: RaisedButton(
			color: Color(0xff2c334f),
			onPressed: () {
			  if(formkey.currentState.validate()){ 
			    setState((){
			      successful = true;
			      email_exists = false;
			      validated = false;
			    });
			    registerNewUser(emailController.text, passwordController.text);
			  }
			},
			child: Text(
			  "Sign Up",
			  style: TextStyle(fontSize: 18.7, color: Colors.white, fontFamily: 'Mohave',),
			),
			shape: RoundedRectangleBorder(
			  borderRadius: BorderRadius.circular(10.0),
			),
		      ),
		    ),
		SizedBox(height:20),
		validated ? Text("Successful validation! Please verify your email address, which is a one time process, by going to your email inbox.",
		  style: TextStyle(fontSize:17, color: Colors.white), textAlign: TextAlign.center,):SizedBox(),
		email_exists ? Text("User with that e-mail already exists",
		  style: TextStyle(fontSize:17, color: Colors.white), textAlign: TextAlign.center,):SizedBox(),
	      ]
	    )
	  )
	);
      }
    );
  }

  bool validateStructure(String value){ 
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  remove_errors_from_screen(){
    setState((){ 
      validated = false;
      email_exists = false;
      successful = false;
    });
  }

  FirebaseAuth auth = FirebaseAuth.instance; 

  Future<void> registerNewUser(email, password) async{
    bool flag = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword( 
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
