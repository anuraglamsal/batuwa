import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firsttimelogin.dart';
import 'normalscreen.dart';
import 'cloud.dart';
import 'usernamescreen.dart';
import 'profpicscreen.dart';

class userscreen extends StatelessWidget{
  @override
  Widget build(BuildContext build){
    return StreamBuilder(
      //This stream fetches the documents in the 'token' collection in the database in Firebase.
      stream: FirebaseFirestore.instance.collection('token').doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
      builder: (context, snapshot){
	if(snapshot.connectionState == ConnectionState.waiting){
	  return Container(color: Color(0xff0e0f26),);
	}
	else if(snapshot.data['token'] == 1){ //When the token is '1' the user is sent to the 'firsttimelogin' page.
	  return Scaffold(
	    appBar: AppBar(
	      title: Center(child: Text("batuwa", style: TextStyle(fontFamily: 'Mohave',))),
	      backgroundColor: Color(0xff252a42),
	    ),
	    body: Container(
	      alignment: Alignment.center,
	      color: Color(0xff0e0f26),
	      child: firsttimeLogin(),
	    ),
	  );
	}
	else if(snapshot.data['token'] == 0){ //When the token is '0' the user is sent to the 'normalscreen' page.
	  return normalscreen();     
	}
	else{
	  if(snapshot.data['token'] == -1){ //When the token is '-1' the user is sent to the 'usernamescreen' page.
	    return usernamescreen();
	  }
	  else{
	    return profpicscreen(); //When the token is '-2' the user is sent to the 'profpicscren' page.
	  }
	}
      }
    );
  }

}
