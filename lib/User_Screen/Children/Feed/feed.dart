import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Children/map.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
	actions: [
	  IconButton(
	    icon: Icon(Icons.search),
	    onPressed: (){
	      showSearch(context: context, delegate: UserSearch(),);
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


  logout() async{ //Signs the user out.
    await FirebaseAuth.instance.signOut();
  }

}

class UserSearch extends SearchDelegate<String>{
  var url;
  @override
  List<Widget> buildActions(BuildContext context){ //Widgets to show to the right of the search bar
    return [
      IconButton(
	icon: Icon(Icons.clear),
	onPressed: (){
	  query = ''; //this clears the search bar when the user presses the icon button.
        },
      ),
    ];
  }
  @override
  Widget buildLeading(BuildContext context){ //Widgets to show to the left of the search bar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
	close(context, null); //This takes us back to the feed.
      },
    );
  }
  @override
  Widget buildResults(BuildContext context){ //The widget to show when the user presses submit after completing entering their search query.
    return Container();
  }
  @override
  Widget buildSuggestions(BuildContext context){ //The suggestions to show when the user is entering something in the search bar but hasn't submitted
						 //yet.
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('token').get(),
      builder: (context, snapshot){
	if(!snapshot.hasData){ 
	  return Container(); //Basically don't show anything when there is no data.
        }
	var list = List();
	for(int i=0; i < snapshot.data.docs.length; ++i){
	  if(query.length <= snapshot.data.docs[i]['username'].length){
	    if(query.toLowerCase() == snapshot.data.docs[i]['username'].toLowerCase().substring(0, query.length) && query.length != 0){
	      list.add(snapshot.data.docs[i]);
	      if(list.length == 5){ //How many users to show on screen?
		break;
	      }
	    }
	  }
        }
	bool flag = false;
	return ListView(
	  children: list.map((user){
	    return FutureBuilder(
	      future: firebase_storage.FirebaseStorage.instance.ref('ProfPic/${user.id}').getDownloadURL(),
	      builder: (context, snapshot){
		if(!snapshot.hasData){
		  return Container();
		}
		return ListTile(
		  leading: CircleAvatar(
		    backgroundImage: NetworkImage(snapshot.data)),
		  title: Text(user["username"],),
		);
	      }
	    );
	  }).toList(),
	);
      }
    );
  }
}


