import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'homescreen.dart';
import 'userscreen.dart';
import 'connection.dart';
import 'null_check.dart'; 

Future<void> main() async{ //You need to initialize the "main" function in this particular manner for Firebase to be initialized.
  WidgetsFlutterBinding.ensureInitialized();//Required to initialize Firebase.
  await Firebase.initializeApp();//Same as above.
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider( //This allows for "MyApp" to get values sent from "signinform" through "Connection_1" in real-time.
      create: (_) => new Connection_1(), //Just initialize the connecting class here in this particular manner.
      child: Consumer<Connection_1>( //Again, just some initialization code.
	builder: (context, check, _) => MaterialApp( //The "check" here should be whatever name that you set for the variable in the 
	                                             //the widget connected to this. This variable carries the value sent from that connected widget.
	  title: 'App',
	  home: (null_test() || check.logged) ? userscreen() : home(), //Straightforward logic for page routing based on persistent user
	                                                               //and newly logged in.
	),
      ),
    );
  }
}


