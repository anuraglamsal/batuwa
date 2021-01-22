import 'package:flutter/material.dart'; 
import 'package:email_validator/email_validator.dart';

class ForgotPassword extends StatefulWidget{
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>{
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
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
	    mainAxisAlignment: MainAxisAlignment.center,
	    children: <Widget>[
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
	      SizedBox(height: 15),
	      Container(
		height: 42, 
		child: RaisedButton(
		  color: Color(0xff2c334f),
		  onPressed: () {
		    if(formkey.currentState.validate()){  
		      //Call the function
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
	    ],
	  ),
	),
      ),
    );
  }
}

