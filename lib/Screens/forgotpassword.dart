import 'package:flutter/material.dart'; 
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget{
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>{
  bool success = false;
  bool failure = false;
  bool circle = false;
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
	title: Container(
	  alignment: Alignment(-0.2, 0),
	  child: Text(
	    "batuwa",
	    style: TextStyle(
	      fontFamily: 'Mohave',
	    ),
	  ),
	),
	backgroundColor: Color(0xff252a42),
      ),
      body: Form(
	key: formkey,
	child: Container(
	  alignment: Alignment.center,
	  color: Color(0xff0e0f26),
	  child: Column(
	    mainAxisAlignment: MainAxisAlignment.start,
	    children: [
	      SizedBox(height: 20),
	      Container(
		height: 90,
		width: 390,
		alignment: Alignment.center,
		decoration: BoxDecoration(
		  color: Color(0xff2c334f),
		  borderRadius: BorderRadius.all(Radius.circular(15)),
		),
		child: Text(
		  "Please write your e-mail address here and click send. We'll send you an email providing further instructions.", 
		  textAlign: TextAlign.center,
		  style: TextStyle(fontSize: 21, color: Colors.white, fontFamily: 'Mohave',),
		),
	      ),
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
		      remove_all_errors();
		      return "Required"; 
		    }
		    else{
		      if(!EmailValidator.validate(value)){
			remove_all_errors();
			return "Not a valid email";
		      }
		    }
		  },
		),
	      ),
	      SizedBox(height: 15),
	      circle ?
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
			    circle = true;
			    success = false;
			    failure = false;
			  });
			  resetPassword(emailController.text);
			}
		      },
		      child: Text(
			"Send",
			style: TextStyle(fontSize: 18.7, color: Colors.white, fontFamily: 'Mohave'),
		      ),
		      shape: RoundedRectangleBorder(
			borderRadius: BorderRadius.circular(10.0),
		      ),
		    ),
		  ),
              SizedBox(height: 15),
	      success ?
		  Text("Please check your inbox.", style: TextStyle(fontSize: 17, color: Colors.blue[100], fontFamily: 'Mohave',),) : SizedBox(),
	      failure ? 
		  Text("This e-mail doesn't exist in the database.", style: TextStyle(fontSize: 17, color: Colors.red[400], fontFamily: 'Mohave',), 
		    textAlign: TextAlign.center,)
		  : SizedBox(),
	    ],
	  ),
	),
      ),
    );
  }

  remove_all_errors(){
    setState((){
      success = false;
      failure = false;
      circle= false;
    });
  }

  FirebaseAuth auth = FirebaseAuth.instance; //This instance is required to use FirebaseAuth services. 
  				             //Read their doc: https://firebase.flutter.dev/docs/auth/usage/

  resetPassword(email) async{ //This function sends an email to the user regarding password change.
    bool flag = true; 
    try{
      await auth.sendPasswordResetEmail(email: email); //This method particularly sends the email.
    }
    on FirebaseAuthException catch (e){ //Exception handling.
      flag = false;
      if (e.code == 'user-not-found'){ //When the user is not found, the respective error message is shown on screen.
	setState((){
	  success = false;
	  failure = true;
	  circle = false;
	});
      }
    }
    if(flag){ //When the flag is true, then that means the email was successfully sent, thus, that particular message is shown on the app's screen.
      setState((){
	success = true;
	failure = false;
	circle = false;
      });
    }
  }

}



