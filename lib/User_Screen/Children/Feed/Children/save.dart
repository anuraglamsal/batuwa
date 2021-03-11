import 'package:flutter/material.dart';

class savescreen extends StatefulWidget{
  @override
  _savescreenState createState() => _savescreenState();
}

class _savescreenState extends State<savescreen>{
  bool circle = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
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
      body: Container(
	alignment: Alignment.center,
	color: Color(0xff0e0f26),
	child: Column(
	  children: [
	    SizedBox(height: 20),
	    Container(
	      height: 60,
	      width: 370,
	      alignment: Alignment.center,
	      decoration: BoxDecoration(
		color: Color(0xff2c334f),
		borderRadius: BorderRadius.all(Radius.circular(15)),
	      ),
	      child: Text(
		"The name you want to give to this location", 
		textAlign: TextAlign.center,
		style: TextStyle(fontSize: 21, color: Colors.white, fontFamily: 'Mohave',),
	      ),
	    ),
	    Form(
	      key: formkey,
	      child: Container(
		width: 330,
		child:TextFormField(
		  controller: name, 
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
		      setState((){
			circle = false;
		      });
		      return "Required"; 
		    }
		  },
		),
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
			});
		      }
		    },
		    child: Text(
		      "Save",
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
    );
  }
}

