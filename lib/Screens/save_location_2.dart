import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class save_screen_2 extends StatefulWidget{
  final double lat;
  final double long;
  final String ease_desc;
  final String name;
  final double ease_rating;
  final List<GeoPoint> polyline;
  const save_screen_2(this.lat, this.long, this.ease_desc, this.name, this.ease_rating, this.polyline);
  @override
  _save_screen_2State createState() => _save_screen_2State();
}

class _save_screen_2State extends State<save_screen_2>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
	title: Container(
	  alignment: Alignment(-0.2, 0),
	  child: Text(
	    "batuwa",
	    style: TextStyle(
	      fontFamily: 'Mohave',
	    ),
	  ),
	),
	backgroundColor: Color(0xff252a42),
      ),
      body: Container(
	alignment: Alignment.center,
	color: Color(0xff0e0f26),
	child: Column(
	  children: [
	  ],
	),
      ),
    );
  }
}


