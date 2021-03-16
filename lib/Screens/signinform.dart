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
  @override
  Widget build(BuildContext context){
    return KeyboardVisibilityBuilder( //Detects if there is keyboard on the screen. This allows us to do stuff depending upon keyboard being on 
                                      //screen or not without using "setState" which is pretty neat.
      builder: (context, isKeyboardVisible){
	return Form(
	  key: formkey, 
	  child: Container(
	    alignment: Alignment.center, 
	    color: Color(0xff0e0f26),
	    child: Column(
	      mainAxisAlignment: MainAxisAlignment.start, 
	      children: [
		SizedBox(height: 10),
		!isKeyboardVisible ? 
		Image.asset('assets/images/logo2.png', width: 300, height: 150):SizedBox(), //The logo is removed when the keyboard is on screen
		                                                                            //to allow for more space.
		Container(
		  height: 58,
		  width: 350,
		  alignment: Alignment.center,
		  decoration: BoxDecoration(
		    color: Color(0xff2c334f),
		    borderRadius: BorderRadius.all(Radius.circular(15)),
		  ),
		  child: Text(
		    "Access your account here",
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
		    style: TextStyle(fontSize: 19.5, color: Colors.white, fontFamily: 'Mohave'),
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
		      else if(!verifyPasswordRules(value)){
			remove_errors_from_screen();
			return "Password should be a combination of at least one of each of uppercase and lowercase letters, digits and special characters (! @ # \$ & * ~ ).";
		      }
		    },
		    obscureText: true 
		  ),
		),
		SizedBox(height: 15),
		GestureDetector(
		  child: Text("Forgot your password?", style: TextStyle(fontSize: 15, color: Colors.lightBlue, fontFamily: 'Mohave',)),
		  onTap: (){
		    Navigator.push(
		      context, 
		      MaterialPageRoute(builder: (context) => ForgotPassword()),
		    );
		  },
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
			    setState((){ //Whenever you press sign-in and if the normal validation is successful, then a loading circle
			                 //is shown on screen rather than the sign in button.
			      successful = true;
			      emailnotfound = false;
			      wrongpassword = false;
			      verifyyouremail = false;
			    });
			    signinUser(emailController.text, passwordController.text);
			  }
			},
			child: Text(
			  "Sign In",
			  style: TextStyle(fontSize: 18.7, color: Colors.white, fontFamily: 'Mohave'),
			),
			shape: RoundedRectangleBorder(
			  borderRadius: BorderRadius.circular(10.0),
			),
		      ),
		    ),
		    SizedBox(height:20),
		    emailnotfound ?
			Text("The email entered doesn't exist in the database.",
			  style: TextStyle(fontSize:17, color: Colors.red[400], fontFamily: 'Mohave',), textAlign: TextAlign.center,):SizedBox(),
		    wrongpassword ?
			Text("The password entered is wrong.",
			  style: TextStyle(fontSize:17, color: Colors.red[400], fontFamily: 'Mohave',), textAlign: TextAlign.center,):SizedBox(),
		    verifyyouremail ?
			Text("Email verification not completed.",
		         style: TextStyle(fontSize:17, color: Colors.red[400], fontFamily: 'Mohave',), textAlign: TextAlign.center,):SizedBox(),
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
