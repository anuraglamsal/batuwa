import 'package:flutter/material.dart';
import '../../Cloud_Firestore/cloud.dart';

//This is the page that the user is directed to when they login for the first time i.e. when their token is '1'.
class firsttimeLogin extends StatefulWidget{
  @override
  _firsttimeLoginState createState() => _firsttimeLoginState();
}

class _firsttimeLoginState extends State<firsttimeLogin>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
	SizedBox(height: 50),
	Image.asset('assets/images/logo.png', width: 300, height: 150),
	Container(
	  height: 70,
	  width: 300,
	  alignment: Alignment.center,
	  decoration: BoxDecoration(
	    color: Color(0xff2c334f),
	    borderRadius: BorderRadius.all(Radius.circular(15)),
	  ),
	  child: Text(
	    "Welcome to batuwa", style: TextStyle(color: Colors.white, fontFamily: 'Mohave', fontSize: 33,),
	  ),
	),
	SizedBox(height: 25),
	GestureDetector(
	  child: Container(
	    height: 50,
	    width: 250,
	    alignment: Alignment.center,
	    decoration: BoxDecoration(
	      color: Colors.blue[600],
	      borderRadius: BorderRadius.all(Radius.circular(15)),
	    ),
	    child: Text(
	      "Start posting right away", style: TextStyle(color: Colors.white, fontFamily: 'Mohave', fontSize: 22,),
	    ),
	  ),
	  onTap: (){
	    update_token(0); //When they press this container, the token is updated to '0'. Token logic: shorturl.at/atDIP
	  },
	),
	SizedBox(height: 17),
	Text(
	  "or", style: TextStyle(fontSize: 17, color: Colors.white),
	),
	SizedBox(height: 17),
	GestureDetector(
	  child: Container(
	    height: 50,
	    width: 250,
	    alignment: Alignment.center,
	    decoration: BoxDecoration(
	      color: Colors.blue[600],
	      borderRadius: BorderRadius.all(Radius.circular(15)),
	    ),
	    child: Text(
	      "Customize your profile", style: TextStyle(color: Colors.white, fontFamily: 'Mohave', fontSize: 22,),
	    ),
	  ),
	  onTap: (){
	    update_token(-1); //When they press this container, the token is updated to '-1'. Token logic: shorturl.at/atDIP
	  },
	),
      ],
    );
  }
}
