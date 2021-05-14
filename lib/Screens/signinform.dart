import 'package:flutter/material.dart'; 
import 'package:email_validator/email_validator.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgotpassword.dart';

class signinform extends StatefulWidget{ //Needs to be stateful because we show messages based on errors of sign in.
  @override
  _signinformState createState() => _signinformState();
} 

class _signinformState extends State<signinform>{
  bool emailnotfound = false; //These booleans are used to show error messages.
  bool wrongpassword = false;
  bool verifyyouremail = false;
  bool successful = false;
  TextEditingController emailController = TextEditingController(); //These controllers are used to fetch form-entered data in real-time.
  TextEditingController passwordController = TextEditingController(); 
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Color labelcolor1 = Color(0xff000000);
  Color labelcolor2 = Color(0xff000000);
  var onpressed = null;
  bool password_visibility = false;

  @override
  void initState(){
    super.initState();
    emailController.addListener(change_disable_or_enable);
    passwordController.addListener(change_disable_or_enable);
  }

  change_disable_or_enable(){
    if(emailController.text != "" && passwordController.text != ""){
      setState((){
	onpressed = (){};
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
    return KeyboardVisibilityBuilder( //Detects if there is keyboard on the screen. This allows us to do stuff depending upon keyboard being on 
                                      //screen or not without using "setState" which is pretty neat.
      builder: (context, isKeyboardVisible){
	return Form(
	  key: formkey, 
	  child: Container(
	    alignment: Alignment.center, 
	    color: Color(0xffffffff),
	    child: Column(
	      mainAxisAlignment: MainAxisAlignment.start, 
	      children: [
		SizedBox(height: 37),
		Focus(
		  onFocusChange: (hasFocus){
		    setState((){
		      labelcolor1 = hasFocus ? Color(0xff07B0B5) : Color(0xff000000);
		    });
		  },
		  child: Container(
		    width: 300,
		    color: Color(0xfff2f2f2),
		    child:TextFormField(
		      controller: emailController, 
		      style: TextStyle(color: Colors.black),
		      decoration: InputDecoration(
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
		    color: Color(0xfff2f2f2),
		    width: 300,
		    child: TextFormField(
		      controller: passwordController, 
		      style: TextStyle(color: Colors.black),
		      decoration: InputDecoration(
			suffixIcon: IconButton(
			  onPressed: (){
			    if(!password_visibility){
			      setState((){
				password_visibility = true;
			      });
			    }
			    else{
			      setState((){
				password_visibility = false;
			      });
			    }
			  },
			  icon: Icon(Icons.visibility, color: password_visibility ? Color(0xff07B0B5) : Colors.grey,),
			),
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
		      obscureText: !password_visibility, 
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
			child: Text("SIGN IN",),
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
		SizedBox(height: 6),
		Row(
		  children: [
		    SizedBox(width: 210),
		    GestureDetector(
		      child: Text("Forgot your password?", style: TextStyle(fontSize: 12, color: Color(0xffBBB9B9),)),
		      onTap: (){
			Navigator.push(
			  context, 
			  MaterialPageRoute(builder: (context) => ForgotPassword()),
			);
		      },
		    ),
		  ],
		),
		SizedBox(height: 10),
		Row(
		  children: [
		  ],
		),
  	      ]
            )
          )
        );
      }
    );
  }

  //All of the functions being used in the widget.

  bool verifyPasswordRules(String value){ //This allows us to have the password condition as described above.
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  remove_errors_from_screen(){
    setState((){ 
      emailnotfound = false;
      wrongpassword = false;
      successful = false;
      verifyyouremail = false;
    });
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  signinUser(email, password) async{
    bool flag = true;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword( //Read the 'Flutter Firebase Auth' docs to understand this.
	email: email,
	password: password
      );
    } on FirebaseAuthException catch (e) {
      bool flag = false;
      if (e.code == 'user-not-found') { //If errors are found, show them on screen.
	setState((){ 
	   emailnotfound = true;
	   wrongpassword = false;
	   successful = false;
	   verifyyouremail = false;
        });
      } else if (e.code == 'wrong-password') {
	setState((){
	  emailnotfound = false;
	  wrongpassword = true;
	  successful = false;
	  verifyyouremail = false;
	});
      }
    }
    if(flag){ //If no errors found, you still need to check if the email has been verified or not. 
      if(!auth.currentUser.emailVerified){ //Check if email is verified.
	auth.currentUser.sendEmailVerification(); //If not, send the verification email again.
	await auth.signOut();
	setState((){
	  emailnotfound = false;
	  wrongpassword = false;
	  successful = false;
	  verifyyouremail = true;
        });
      }
    }
  }

} 
