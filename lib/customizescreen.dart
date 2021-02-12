import 'package:flutter/material.dart';

class customizescreen extends StatefulWidget{
  @override
  _customizescreenState createState() => _customizescreenState();
}

class _customizescreenState extends State<customizescreen>{
  GlobalKey<FormState> formkey = GlobalKey<FormState>(); 
  TextEditingController usernameController = new TextEditingController(); 
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
	title: Center(child: Text("batuwa", style: TextStyle(fontFamily: 'Mohave',))),
	backgroundColor: Color(0xff252a42),
      ),
      body: Container(
	color: Color(0xff0e0f26), 
	alignment: Alignment.center,
	child: Column(
	  children: [
	    Form(
	      key: formkey,
	      child: Container(
		width: 330,
		child: TextFormField(
		  controller: usernameController,
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
		  },
		),
	      ),
	    ),
	  ],
	),
      ),
    );
  }
}

