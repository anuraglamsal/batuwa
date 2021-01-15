import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class userscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
	children: <Widget>[
	  SizedBox(height: 40),
	  RaisedButton(
	    child: Text(
	      'Logout',
	    ),
	    onPressed:(){
	      logout();
	    }
	  )
	],
      ),
    );
  }
  void logout() async{
    await FirebaseAuth.instance.signOut();
  }
}
