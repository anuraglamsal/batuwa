import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class normalscreen extends StatefulWidget{
  @override
  _normalscreenState createState() => _normalscreenState();
}

class _normalscreenState extends State<normalscreen>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
	SizedBox(height: 700),
	RaisedButton(
	  child: Text(
	    'Logout',
	  ),
	  onPressed:(){
	    logout();
	  }
	)
      ],
    );
  }

  Future<void> logout() async{ //Signs the user out.
    await FirebaseAuth.instance.signOut();
  }

}

