import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'search_screen.dart';

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
		    logout(); //When the user clicks on the "Logout" button in drawer, the user gets logged out.
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
	actions: [
	  IconButton(
	    icon: Icon(Icons.search),
	    onPressed: (){
	      showSearch(context: context, delegate: UserSearch(),); //This routes us to the search screen.
	    },
	  ),
	],
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
			MaterialPageRoute(builder: (context) => Embark()), //This routes us to the map screen.
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


  logout() async{ //Signs the user out.
    await FirebaseAuth.instance.signOut();
  }

}
