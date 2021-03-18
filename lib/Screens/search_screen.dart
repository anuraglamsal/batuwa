import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';

class UserSearch extends SearchDelegate<String>{
  var list = List();
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
	  onTap: () {
	    Navigator.push(
	      context,
	      MaterialPageRoute(builder: (context) => ProfilePage()),
	    );
	  },
	);
      }).toList(),
    );
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
	  return Center(
	    child: CircularProgressIndicator(),
	  ); //In any other case, an indicator is shown that the user is being searched for.
	}
	list = List(); //The list that stores users to show depending upon the thing written in the search bar.
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
	      onTap: (){
		Navigator.push(
		  context,
		  MaterialPageRoute(builder: (context) => ProfilePage()),
		);
	      },
	    );
	  }).toList(),
	);
      }
    );
  }
}

