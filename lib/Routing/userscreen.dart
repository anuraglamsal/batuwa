import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screens/new_user_screen.dart';
import '../Screens/feed.dart';
import '../Cloud/cloud.dart';
import '../Screens/new_user_username.dart';
import '../Screens/new_user_prof_pic.dart';

class userscreen extends StatelessWidget{
  @override
  Widget build(BuildContext build){
    return StreamBuilder(
      //This stream fetches the documents in the 'token' collection in the database in Firebase.
      stream: FirebaseFirestore.instance.collection('token').doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
      builder: (context, snapshot){
	if(snapshot.connectionState == ConnectionState.waiting){
	  return Container(
	    color: Colors.white,
	    child: Center(
	      child: CircularProgressIndicator(
		valueColor: AlwaysStoppedAnimation<Color>(Color(0xff07B0B5)),
	      ),
	    ),
	  );
	}
	else if(snapshot.data['token'] == 1){ //When the token is '1' the user is sent to the 'firsttimelogin' page.
	  return firsttimeLogin();
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

  logout() async{
    await FirebaseAuth.instance.signOut();
  }

}
