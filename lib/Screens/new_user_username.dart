import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Cloud/cloud.dart';
import 'new_User_prof_pic.dart';

//This is the screen that the user is directed to when the token is '-1'.
class usernamescreen extends StatefulWidget{
  @override
  _usernamescreenState createState() => _usernamescreenState();
}

class _usernamescreenState extends State<usernamescreen>{
  bool successful = false;
  Color labelcolor = Color(0xff000000);
  TextEditingController usernameController = TextEditingController(); 
  GlobalKey<FormState> formkey = GlobalKey<FormState>(); 
  AutovalidateMode _autovalidatemode = AutovalidateMode.disabled;
  var onpressed = null;

  @override
  void initState(){
    super.initState();
    usernameController.addListener(change_disable_or_enable);
  }

  change_disable_or_enable(){
    if(usernameController.text != ""){
      setState((){
	onpressed = (){
	  if(formkey.currentState.validate()){
	    setState((){
	      successful = true;
	      _autovalidatemode = AutovalidateMode.disabled;
	    });
	    check_username(usernameController.text);
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
	title: Center(child: Text("batuwa", style: TextStyle(color: Colors.black, fontFamily: 'Mohave',),),),
	backgroundColor: Color(0xffffffff),
      ),
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
	child: Container(
	  color: Color(0xffffffff), 
	  alignment: Alignment.center,
	  child: Column(
	    children: [
	      SizedBox(height: 19),
	      Container(
		width: 170,
		child: Text(
		  "Enter your desired username",
		  style: TextStyle(
		    fontSize: 13,
		    color: Color(0xffa8a8a8),
		  ),
		),
	      ),
	      SizedBox(height: 15),
	      Form(
		key: formkey,
		autovalidateMode: _autovalidatemode,
		child: Focus(
		  onFocusChange: (hasFocus){
		    setState((){
		      labelcolor = hasFocus ? Color(0xff07B0B5) : Color(0xff000000);
		    });
		  },
		  child: Container(
		    width: 300,
		    child:TextFormField(
		      controller: usernameController, 
		      style: TextStyle(color: Colors.black),
		      decoration: InputDecoration(
			errorMaxLines: 3,
			filled: true,
			fillColor: Color(0xfff2f2f2),
			labelText: "Username",
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
			else if(!validateUsername(value)){
			  return "The username should be 5 to 15 characters in length, and it should only contain letters (both uppercase and lowercase), numbers and underscores."; //The username's validation condition.
			}
		      },
		    ),
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
		      child: Text(
			"NEXT",
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
		  SizedBox(height: 300),
		  Material(
		    color: Colors.transparent,
		    child: InkWell(
		      customBorder: CircleBorder(),
		      child: Container(
			width: 60,
			child: Row(
			  children :[
			    SizedBox(width: 10),
			    Text(
			      "Skip",
			      style: TextStyle(color: Color(0xff757575),),
			    ),
			    Icon(
			      Icons.skip_next,
			      color: Color(0xff757575),
			      size: 22,
			    ),
			  ],
			),
		      ),
		      onTap: (){
			Navigator.push(
			  context, 
			  MaterialPageRoute(builder: (context) => (profpicscreen())),
			);
		      },
		    ),
		  ),
		],
	      ),
	    ),
	  ),
	);
      }

  bool validateUsername(String value){ //Regex that checks if the username is valid. 
    String pattern = r'^[A-Za-z0-9_]{5,15}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
 
  check_username(username) async{
    final doc = await FirebaseFirestore.instance.collection('token').where('username', isEqualTo: username).get(); //This method fetches
    //the documents where the 'username' field is the username given by the user.
    if(doc.size == 0){ //If there is no document like that, then the username is not used before, thus allowed.
      update_username(username); //This updates the user's username. The function is in 'cloud.dart'.
      Navigator.push(
	context, 
	MaterialPageRoute(builder: (context) => (profpicscreen())),
      );
    }
    else{
      setState((){
	successful = false;
      });
      return showDialog(
	context: context,
	builder: (_) => AlertDialog(
	  content: Text("This username already exists.",),
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

}
