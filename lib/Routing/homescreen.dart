import 'package:flutter/material.dart';
import '../Screens/signupform.dart';
import '../Screens/signinform.dart';

class home extends StatefulWidget{ //"home" is stateful because "BottomNavigationBar" is being used.
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home>{
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
	backgroundColor: Colors.white,
	appBar: AppBar(
	  bottom: TabBar(
	    indicatorColor: Color(0xff07B0B5),
	    indicatorWeight: 3,
	    tabs: [
	      Tab(child: Text("SIGN IN", style: TextStyle(color: Colors.black,),),),
	      Tab(child: Text("SIGN UP", style: TextStyle(color: Colors.black,),),),
	    ],
	  ),
	  title: Container(
	    alignment: Alignment.center,
	    child: Text(
	      "batuwa",
	      style: TextStyle(
		fontFamily: 'Mohave',
		color: Colors.black,
	      ),
	    ),
	  ),
	  backgroundColor: Color(0xffffffff),
	),
	body: TabBarView(
	  children: [
	    signinform(),
	    signupform(),
	  ],
	),
      ),
    );
  }
}

