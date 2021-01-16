import 'package:flutter/material.dart';//for flutter syntax 
import 'package:email_validator/email_validator.dart';//for email validator
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:firebase_auth/firebase_auth.dart';//for firebase auth
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'userscreen.dart';
import 'connection.dart';
import 'auth.dart';


class signinform extends StatefulWidget{
  @override
  _signinformState createState() => _signinformState();
} 

class _signinformState extends State<signinform>{
  var check;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool emailnotfound = false;
  bool wrongpassword = false;
  bool verifyyouremail = false;
  bool successful = false;
  TextEditingController emailController = new TextEditingController(); 
  TextEditingController passwordController = new TextEditingController(); 
  @override
  Widget build(BuildContext context){
    get_context(context);
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible){
	return Form(
	  key: formkey, 
	  child: Container(
	    alignment: Alignment.center, 
	    color: Colors.black87,
	    child: Column(
	      mainAxisAlignment: MainAxisAlignment.start, 
	      children: <Widget>[
		SizedBox(height: 10),
		!isKeyboardVisible ? 
		Image.asset('assets/images/logo2.png', width: 300, height: 150):SizedBox(),
		Container(
		  height: 58,
		  width: 350,
		  alignment: Alignment.center,
		  decoration: BoxDecoration(
		    color: Colors.blueGrey[700],
		    borderRadius: BorderRadius.all(Radius.circular(15)),
		  ),
		  child: Text(
		    "Access your account here",
		    style: TextStyle(fontSize: 26, color: Colors.white),
		  ),
		),
		SizedBox(height: 17),
		Container(
		  alignment: Alignment.center,
		  height: 50,
		  width: 330,
		  decoration: BoxDecoration(
		    color: Colors.blueGrey[800],
		    borderRadius: BorderRadius.all(Radius.circular(20)),
		  ),
		  child: Text(
		    "E-mail",
		    style: TextStyle(fontSize: 22, color: Colors.white,),
		  )
		),                                                            
		SizedBox(height:10),
		Container(
		  width: 330,
		  child:TextFormField(
		    controller: emailController, 
		    style: TextStyle(color: Colors.white),
		    decoration: InputDecoration(
		      enabledBorder: OutlineInputBorder(
			borderSide: BorderSide(
			  color:Colors.blueGrey[700],
			),
		      ),
		      border: OutlineInputBorder(),
		      focusedBorder: OutlineInputBorder(
			borderSide: const BorderSide(color: Colors.blueGrey, width: 2.0),	
		      ),
		    ),
		    cursorColor: Colors.blueGrey,
		    validator: (value){  
		      if(value.isEmpty){
			setState((){ 
			  emailnotfound = false;
			  wrongpassword = false;
			  successful = false;
			  verifyyouremail = false;
			});
			return "Required"; 
		      }
		      else{
			if(!EmailValidator.validate(value)){
			  setState((){
			    emailnotfound = false;
			    wrongpassword = false;
			    successful = false;
			    verifyyouremail = false;
			  });
			  return "Not a valid email";
			}
		      }
		    },
		  ),
		),
		SizedBox(height: 10),
		Container(
		  alignment: Alignment.center,
		  height: 50,
		  width: 330,
		  decoration: BoxDecoration(
		    color: Colors.blueGrey[800],
		    borderRadius: BorderRadius.all(Radius.circular(20)),
		  ),
		  child: Text(
		    "Password",
		    style: TextStyle(fontSize: 22, color: Colors.white,),
		  )
		),
		SizedBox(height: 10),
		Container(
		  width: 330,
		  child: TextFormField(
		    controller: passwordController, 
		    style: TextStyle(color: Colors.white),
		    decoration: InputDecoration(
		      errorMaxLines: 3,
		      enabledBorder: OutlineInputBorder(
			borderSide: BorderSide(
			  color:Colors.blueGrey[700],
			),
		      ),
		      border: OutlineInputBorder(),
		      focusedBorder: OutlineInputBorder(
			borderSide: const BorderSide(color: Colors.blueGrey, width: 2.0),	
		      ),
		    ),
		    cursorColor: Colors.blueGrey,
		    validator: (value){ 
		      if(value.isEmpty){
			setState((){
			  emailnotfound = false;
			  wrongpassword = false;
			  successful = false;
			  verifyyouremail = false;
			});
			return "Required";
		      }
		      else if(value.length<12){
			setState((){
			  emailnotfound = false;
			  wrongpassword = false;
			  successful = false;
			  verifyyouremail = false;
			});
			return "A password of length more than or equal to 12 is required";
		      }
		      else if(!validateStructure(value)){
			setState((){
			  emailnotfound = false;
			  wrongpassword = false;
			  successful = false;
			  verifyyouremail = false;
			});
			return "Password should be a combination of at least one of each of uppercase and lowercase letters, digits and special characters (! @ # \$ & * ~ ).";
		      }
		    },
		    obscureText: true 
		  ),
		),
		SizedBox(height: 15),
		GestureDetector(
		  child: Text("Forgot your password?", style: TextStyle(fontSize: 15, color: Colors.lightBlue)),
		  onTap: (){
		    _launchURL();
		  },
		),
		SizedBox(height: 15),
		Container(
		  height: 42, 
		  child: RaisedButton(
		    color: Colors.blueGrey[700],
		    onPressed: () {
		      if(formkey.currentState.validate()){  
			signinUser(emailController.text, passwordController.text);
		      }
		    },
		    child: Text(
		      "Sign In",
		      style: TextStyle(fontSize: 18, color: Colors.white),
		    ),
		    shape: RoundedRectangleBorder(
		      borderRadius: BorderRadius.circular(10.0),
		    ),
		  ),
		),
		SizedBox(height:20),
		emailnotfound ?
		    Text("The email entered doesn't exist in the database.",
		         style: TextStyle(fontSize:17, color: Colors.white), textAlign: TextAlign.center,):SizedBox(),
		wrongpassword ?
		    Text("The password entered is wrong.",
		         style: TextStyle(fontSize:17, color: Colors.white), textAlign: TextAlign.center,):SizedBox(),
                verifyyouremail ?
		    Text("Email verification not completed.",
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

  get_context(BuildContext context){
    check = Provider.of<Connection>(context);
  }

  Future<void> signinUser(email, password) async{
    bool flag = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
	email: email,
	password: password
      );
    } on FirebaseAuthException catch (e) {
      bool flag = false;
      if (e.code == 'user-not-found') {
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
    if(flag){
      if(!auth.currentUser.emailVerified){
	auth.currentUser.sendEmailVerification();
	setState((){
	  emailnotfound = false;
	  wrongpassword = false;
	  successful = false;
	  verifyyouremail = true;
        });
      }
      else{
	check.logged = true;
      }
    }
  }

  void _launchURL() async {
    const url = 'https://google.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

} 
