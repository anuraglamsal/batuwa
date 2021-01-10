import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signinform.dart';

class userscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      child: RaisedButton(
	child: Text(
	  'Logout',
	),
	onPressed:(){
	  logout();
	  Navigator.push(
	    context,
	    MaterialPageRoute(builder: (context) => signinform()),
	  );
	}
      )
    );
  }
  void logout() async{
    await FirebaseAuth.instance.signOut();
  }
}
