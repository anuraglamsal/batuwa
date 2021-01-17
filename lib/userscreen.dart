import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'connection.dart';
import 'null_check.dart';

class userscreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final check = Provider.of<Connection_1>(context);//We are also connecting this widget to "MyApp". You have to use the same variable name.
    return Container(
      child: Column(
	children: <Widget>[
	  SizedBox(height: 40),
	  RaisedButton(
	    child: Text(
	      'Logout',
	    ),
	    onPressed:(){
	      logout();
	      Future.delayed(const Duration(milliseconds: 500), (){ //This is because we encounter syncing problems as signing out takes a bit of time.
		check.logged = false;
	      });
	    }
	  )
	],
      ),
    );
  }
}
