import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firsttimelogin.dart';
import 'normalscreen.dart';

class userscreen extends StatelessWidget{
  @override
  Widget build(BuildContext build){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('token').doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
      builder: (context, snapshot){
	if(snapshot.connectionState == ConnectionState.waiting){
	  return Container(color: Color(0xff0e0f26),);
        }
	else{
	  if(snapshot.data['token'] == 1){
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
	  else{
	    return Scaffold(
	      drawer: Drawer(
		child: ListView(
		),
	      ),
	      appBar: AppBar(
		title: Container(alignment: Alignment(-0.21, 0), child: Text("batuwa", style: TextStyle(fontFamily: 'Mohave',))),
		backgroundColor: Color(0xff252a42),
	      ),
	      body: Container(
		alignment: Alignment.center,
		color: Color(0xff0e0f26),
		child: normalscreen(),
	      ),
	    );
  	  }
        }
      },
    );
  }
}
