import 'package:flutter/material.dart';
import 'signupform.dart';
import 'signinform.dart';

class home extends StatefulWidget{//We make the 'home' stateful because we want to change the contents of the body when we navigate around the
                                  //bottom bar. We could I guess make it more efficient, but I don't think the performance is going to get hampered
                                  //too much doing this and this is more convinient. 
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home>{
  int _currentIndex = 0;//this allows us to change the item of the bottom bar according to the whim of the user. This changes depending upon
                        //what item the user taps. The default is '0' which is the first item going from left to right.
  final tabs = [//This allows us to have different things in screen according to the item of the bottom bar we are on right now.
                //If we tap the first item, the first widget in this list is loaded, and if we tap the second item, the second widget is loaded and so on.
    signupform(),
    signinform(),//sign in to be here
  ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
	title: Container(
	  alignment: Alignment.center,
	  child: Text(
	    "batuwa",
	  ),
	),
	backgroundColor: Colors.blueGrey[800],
      ),
      body: tabs[_currentIndex],//This selects the widgets from the list above according to the index i.e. the item of the bottom bar we are at right now.
      bottomNavigationBar: BottomNavigationBar(//We are creating the bottom bar here.
	currentIndex : _currentIndex,//Here is actually where we provide the variable created above. Default is 0, thus the first item on the bottom
	                             //bar is selected. If _currentIndex was 1, the second item would be selected. The logic of how this is changed
	                             //according to the whim of the user is below.
	backgroundColor: Colors.blueGrey[800],
	selectedItemColor: Colors.white,
	unselectedItemColor: Colors.grey,
	items: [//These are the items in the bottom bar.
	  BottomNavigationBarItem(
	    icon: Icon(Icons.add_box_rounded),
	    title: Text('Sign Up'),
	    backgroundColor: Colors.blue,
	  ),
	  BottomNavigationBarItem(
	    icon: Icon(Icons.account_box_rounded),
	    title: Text('Sign In'),
	    backgroundColor: Colors.blue,
	  ),
	],
	onTap: (index){//With this, when we tap an item, the index corresponding to that item comes up here. 
	  setState((){//We change the _currentIndex variable here to the index of the item that the user has selected. Thus, now, when 'setState'
	              //rebuilds our home screen, the item on the bottom bar that is selected changes in the UI because the value given to 
	              //'currentIndex' above has changed.
	    _currentIndex = index;
	  });
        }
      ),
    );
  }
}

