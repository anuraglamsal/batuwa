import 'package:flutter/material.dart';//for everything
import 'package:firebase_core/firebase_core.dart';//for firebase bootstrapping
import 'package:provider/provider.dart';
import 'homescreen.dart';
import 'userscreen.dart';
import 'connection.dart';
import 'null_check.dart';

Future<void> main() async{ //you also need to declare the main function in this particular way for firebase initialization.
  WidgetsFlutterBinding.ensureInitialized();//required for firebase bootstrapping (you have to do this in order for firebase plugins to work)
  await Firebase.initializeApp();//same as above
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (_) => new Connection(),
      child: Consumer<Connection>(
	builder: (context, check, _) => MaterialApp(
	  title: 'App',
	  home: (null_test() || check.logged) ? userscreen() : home(),
	),
      ),
    );
  }
}


