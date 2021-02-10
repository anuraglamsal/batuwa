import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class normalscreen extends StatefulWidget{
  @override
  _normalscreenState createState() => _normalscreenState();
}

class _normalscreenState extends State<normalscreen>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
	SizedBox(height: 100),
	Row(
	  mainAxisAlignment: MainAxisAlignment.center,
	  children: [
	    Container(
	      width: 60,
	      height: 60,
	      decoration: BoxDecoration(
		color: Colors.orange,
		shape: BoxShape.circle,
	      ),
	    ),
	    SizedBox(width: 50),
	    Container(
	      height: 100,
	      width: 200,
	      child: ElevatedButton(
		child: Text("EMBARK",),
		onPressed: (){
		  Navigator.push(
		    context,
		    MaterialPageRoute(builder: (context) => Embark()),
		  );
		},
	      ),
	    ),
	  ],
	),
	SizedBox(height: 400),
      ],
    );
  }
}

class Embark extends StatefulWidget{
  @override
  _EmbarkState createState() => _EmbarkState();
}

class _EmbarkState extends State<Embark>{
  @override
  Widget build(BuildContext context){
    return Text("YEP",);
  }
}


