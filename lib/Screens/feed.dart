import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map.dart';
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

class UserSearch extends SearchDelegate<String>{
  var url;
  @override
  List<Widget> buildActions(BuildContext context){ //Widgets to show to the right of the search bar
    return [
      IconButton(
	icon: Icon(Icons.clear),
	onPressed: (){
	  query = ''; //this clears the search bar when the user presses the icon button. The 'query' variable always contains what is written in the
	              //search bar.	
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
						 //yet. Whenever the content written in the search bar changes, this widget is rebuilt.
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('token').get(), //This returns a future which is a list of all users.
      builder: (context, snapshot){
	if(!snapshot.hasData){ //It takes some time, although very little, to get the list of all users. So you return the widget to show when the user 
	  		       //list hasn't been received yet here. The querying of the list is so fast, that most of the time this isn't even
	  		       //run.
	  if(query == ''){ //It doesn't make sense to show that something is loading when there is nothing written on the search bar, thus, an empty
	       	           //container is shown.	
	    return Container();
	  }
	  return CircularProgressIndicator(); //In any other case, an indicator is shown that the user is being searched for.
	}
	var list = List(); //The list that stores users to show depending upon the thing written in the search bar.
	for(int i=0; i < snapshot.data.docs.length; ++i){ //This is the logic to filter users from the queried list depending upon the 
	  						  //thing written on the search bar. The valid users are added on the list made above.
	  						  //The logic is very naive, but it works for now.  
	  if(query.length <= snapshot.data.docs[i]['username'].length){ 
	    if(query.toLowerCase() == snapshot.data.docs[i]['username'].toLowerCase().substring(0, query.length) && query.length != 0){
	      list.add(snapshot.data.docs[i]);
	      if(list.length == 5){ //How many users to show on screen?
		break;
	      }
	    }
	  }
	}
	if(list.length == 0){ //We do this because if the list is null, it causes some "null" related problems.
	  list.add(0);
        }
	return ListView(
	  children: list.map((user){
	    if(user == 0 && query != ''){ //If no user from the queried user list matched the logic above, we show that there is no user like that. 
	      return ListTile(
		title: Text("No user like that.",),
	      );
	    }
	    if(query == ''){ //If there is nothing written on the search bar, we just show nothing bascially.
	      return ListTile();
	    }
	    return ListTile( //Here, all of the user's in the list are shown in a list form. 
	      leading: CircleAvatar(
		backgroundImage: (user["profpicURL"] == "") ? AssetImage(
		  'assets/images/ProfilePic.png',
		) : NetworkImage(user["profpicURL"]), //Handling cases when there is no profile picture uploaded by the user.
	      ),
	      title: Text(user["username"],),
	    );
	  }).toList(),
	);
      }
    );
  }
}


