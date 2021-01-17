import 'package:flutter/material.dart';
import 'signupform.dart';
import 'signinform.dart';

class home extends StatefulWidget{ //"home" is stateful because "BottomNavigationBar" is being used.
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home>{
  int _currentIndex = 0; //This variable stores the indices representing the tabs.
  final tabs = [ //The widgets that we keep inside this, in a consequential manner, are the contents of the tabs.
    signupform(), //The first widget here is the content of the first tab.
    signinform(), //The second widget here is the content of the second tab and so on.
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
      body: tabs[_currentIndex], //This allows for "tabs" above to work. 
      bottomNavigationBar: BottomNavigationBar(
	currentIndex : _currentIndex, //The value of the "_currentindex" variable provided here controls what tab is opened. '0' is the leftmost 
	                              //tab and it goes one more to the right as you increase '1' and so on similarly.
	backgroundColor: Colors.blueGrey[800],
	selectedItemColor: Colors.white,
	unselectedItemColor: Colors.grey,
	items: [ //These are the items in the bottom navigation bar. 
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
	onTap: (index){ //Each time you tap on a tab, the "index" here gets the index value of the tab tapped. This allows us to open contents
	                //of that tab by changing the state of the screen by providing "_currentIndex" the tapped tab's index value. 
	  setState((){	   
	    _currentIndex = index;
	  });
        }
      ),
    );
  }
}

