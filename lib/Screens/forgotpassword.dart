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
  Color labelcolor = Color(0xff000000);
  var onpressed = null;
  AutovalidateMode _autovalidatemode = AutovalidateMode.disabled;
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    emailController.addListener(change_disable_or_enable);
  }

  change_disable_or_enable(){
    if(emailController.text != ""){
      setState((){
	onpressed = (){
	  if(formkey.currentState.validate()){
	    setState((){
	      circle = true;
	      _autovalidatemode = AutovalidateMode.disabled;
	    });
	    resetPassword(emailController.text);
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
    return Scaffold(
      appBar: AppBar(
	elevation: 0,
	leading: BackButton(
	  color: Colors.black,
	),
	title: Container(
	  alignment: Alignment(-0.26, 0),
	  child: Text("batuwa", style: TextStyle(color: Colors.black, fontFamily: 'Mohave',),),
	),
	backgroundColor: Color(0xffffffff),
      ),
      body: Form(
	key: formkey,
	autovalidateMode: _autovalidatemode,
	child: Container(
	  alignment: Alignment.center,
	  color: Color(0xffffffff),
	  child: Column(
	    mainAxisAlignment: MainAxisAlignment.start,
	    children: [
	      SizedBox(height: 19),
	      Container(
		width: 300,
		child: Text(
		  "Enter the email associated with your account and hit send. We'll send you password reset instructions in that email.",
		  style: TextStyle(
		    fontSize: 13,
		    color: Color(0xffa8a8a8),
		  ),
		),
	      ),
	      SizedBox(height: 15),
	      Focus(
		onFocusChange: (hasFocus){
		  setState((){
		    labelcolor = hasFocus ? Color(0xff07B0B5) : Color(0xff000000);
		  });
		},
		child: Container(
		  width: 300,
		  child:TextFormField(
		    controller: emailController, 
		    style: TextStyle(color: Colors.black),
		    decoration: InputDecoration(
		      filled: true,
		      fillColor: Color(0xfff2f2f2),
		      labelText: "Email",
		      labelStyle: TextStyle(
			color: labelcolor,
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
			return "Required"; 
		      }
		      else{
			if(!EmailValidator.validate(value)){
			  return "Not a valid email";
			}
		      }
		    },
		  ),
		),
	      ),
	      SizedBox(height: 20),
	      circle ?
		  CircularProgressIndicator(
		    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff07B0B5)),
		  ) :
		  Container(
		    height: 42, 
		    width: 300,
		    child: ElevatedButton(
		      onPressed: onpressed,
		      child: Text(
			"SEND",
		      ),
		      style: ButtonStyle(
			backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
		],
	      ),
	    ),
	  ),
	);
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
	  circle = false;
	});
	dialogbox("This email doesn't exist in the database.");
      }
    }
    if(flag){ //When the flag is true, then that means the email was successfully sent, thus, that particular message is shown on the app's screen.
      setState((){
	circle = false;
      });
      dialogbox("Please check your inbox.");
    }
  }

  dialogbox(String message){
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
	content: Text(message,),
	actions: [
	  MaterialButton(
	    child: Text("OK", style: TextStyle(color: Color(0xff07B0B5),),),
	    onPressed: (){
	      Navigator.pop(context);
	    },
	  ),
	],
      ),
    );
  }

}




