import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class save_screen_3 extends StatefulWidget{
  final double lat;
  final double long;
  final String ease_desc;
  final String name;
  final double ease_rating;
  final List<GeoPoint> polyline;
  final double enjoy_rating;
  final String enjoy_desc;
  const save_screen_3(this.lat, this.long, this.ease_desc, this.name, this.ease_rating, this.polyline, this.enjoy_rating, this.enjoy_desc);
  @override
  _save_screen_3State createState() => _save_screen_3State();
}

class _save_screen_3State extends State<save_screen_3>{
  @override
  Widget build(BuildContext context){
    return Container();
  }
}

