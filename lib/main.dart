import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homescreen.dart';
import 'userscreen.dart';

Future<void> main() async{ //You need to initialize the "main" function in this particular manner for Firebase to be initialized.
  WidgetsFlutterBinding.ensureInitialized();//Required to initialize Firebase.
  await Firebase.initializeApp();//Same as above.
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){  //Buildcontext describes where you are in the tree of widgets of your application.
    return StreamBuilder( //Learn about 'streams' before proceeding.
      stream: FirebaseAuth.instance.authStateChanges(), //This stream gives information about whether a user is logged in or not. 
      builder: (context, snapshot){
	if(snapshot.connectionState == ConnectionState.waiting){
	  return Text("YEP");
        }
	else{
	  return MaterialApp(
	    title: 'app',
	    home: (snapshot.data != null && snapshot.data.emailVerified) ? userscreen() : home(), //If the data provided by the stream is null,
	      						//then that means a user isn't logged in, therefore, we should send the user to the 
	   						//'home' screen. Even when it's not null, if the user's email hasn't been verified,
	                                                //then we again send them to the 'home' screen. If both are false, then that means
	                                                //we send the user to their account.
	  );
        }
      },
    );
  }
}


