import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class customizescreen extends StatefulWidget{
  @override
  _customizescreenState createState() => _customizescreenState();
}

class _customizescreenState extends State<customizescreen>{
  bool successful = false;
  bool user_exists = false;
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
	    SizedBox(height:50),
	    Container(
	      alignment: Alignment.center,
	      height: 50,
	      width: 330,
	      decoration: BoxDecoration(
		color: Color(0xff252a42),
		borderRadius: BorderRadius.all(Radius.circular(20)),
	      ),
	      child: Text(
		"What username do you want?",
		style: TextStyle(fontSize: 19.5, color: Colors.white, fontFamily: 'Mohave'),
	      )
	    ),                                                            
	    SizedBox(height:5),
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
		      setState((){
			successful = false;
			user_exists = false;
		      });
		      return "Required";
		    }
		  },
		),
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
			});
			check_username(usernameController.text);
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
	    SizedBox(height: 15),
	    user_exists ? Text("The username is already taken.", style: TextStyle(color: Colors.red[500], fontFamily: 'Mohave', fontSize: 17),) 
		: SizedBox(),
	  ],
	),
      ),
    );
  }
 
  void check_username(username) async{
    final doc = await FirebaseFirestore.instance.collection('token').where('username', isEqualTo: username).get();
    if(doc.size == 0){

    }
    else{
      setState((){
	successful = false;
	user_exists = true;
      });
    }
  }

}

