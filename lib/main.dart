import 'package:flutter/material.dart';//for everything
import 'package:firebase_core/firebase_core.dart';//for firebase bootstrapping
import 'package:firebase_auth/firebase_auth.dart';//for firebase auth
import 'homescreen.dart';
import 'userscreen.dart';

Future<void> main() async{ //you also need to declare the main function in this particular way for firebase initialization.
  WidgetsFlutterBinding.ensureInitialized();//required for firebase bootstrapping (you have to do this in order for firebase plugins to work)
  await Firebase.initializeApp();//same as above
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
      return MaterialApp(
      title: 'App',
      home: home(),
    );
  }
}


