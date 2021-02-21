import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

//The screen that the user is directed to when their token is '0', i.e. this is their feed screen.
class normalscreen extends StatefulWidget{
  @override
  _normalscreenState createState() => _normalscreenState();
}

class _normalscreenState extends State<normalscreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: Drawer(
	child: Container(
	  color: Color(0xff0e0f26),
	  child: ListView(
	    padding: EdgeInsets.zero,
	    children: [
	      SizedBox(height: 50),
	      Material(
		color: Colors.white.withOpacity(0.0),
		child: ListTile(
		  leading: Icon(
		    Icons.account_circle_outlined,
		    color: Colors.white,
		  ),
		  selected: true,
		  title: Text("Customize your profile", style: TextStyle(fontFamily: "Mohave", fontSize: 20, color: Colors.white),),
		  onTap:(){
		  },
		),
	      ),
	      Material(
		color: Colors.white.withOpacity(0.0),
		child: ListTile(
		  leading: Icon(
		    Icons.logout,
		    color: Colors.white,
		  ),
		  selected: true,
		  title: Text("Logout", style: TextStyle(fontFamily: "Mohave", fontSize: 20, color: Colors.white),),
		  onTap:(){
		    logout();
		  },
		),
	      ),
	    ],
	  ),
	),
      ),
      appBar: AppBar(
	title: Container(alignment: Alignment(-0.21, 0), child: Text("batuwa", style: TextStyle(fontFamily: 'Mohave',))),
	backgroundColor: Color(0xff252a42),
      ),
      body: Container(
	alignment: Alignment.center,
	color: Color(0xff0e0f26),
	child: Column(
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
	),
      ),
    );
  }


  Future<void> logout() async{ //Signs the user out.
    await FirebaseAuth.instance.signOut();
  }

}

class Embark extends StatefulWidget{
  @override
  _EmbarkState createState() => _EmbarkState();
}

class _EmbarkState extends State<Embark>{
  @override
  Widget build(BuildContext context){
    return FlutterMap(
      options: new MapOptions(
	center: new LatLng(51.5, -0.09),
	zoom: 17.0,
      ),
      layers: [
	new TileLayerOptions(
	  urlTemplate: 'http://mt{s}.google.com/vt/lyrs=m@221097413,parking,traffic,lyrs=m&x={x}&y={y}&z={z}',
	  maxZoom: 22.0,
	  subdomains: ['0', '1', '2', '3'],
	  retinaMode: true,
	),
	new MarkerLayerOptions(
	  markers: [
	    new Marker(
	      width: 80.0,
	      height: 80.0,
	      point: new LatLng(51.5, -0.09),
	      builder: (ctx) =>
	      new Container(
		child: new FlutterLogo(),
	      ),
	    ),
	  ],
	),
      ],
    );
  }
}


