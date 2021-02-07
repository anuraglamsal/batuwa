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
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
	if(snapshot.connectionState == ConnectionState.waiting){
	  return Text("YEP");
        }
	else{
	  print(snapshot.data);
	  return MaterialApp(
	    title: 'app',
	    home: (snapshot.data != null && snapshot.data.emailVerified) ? userscreen() : home(),
	  );
        }
      },
    );
  }
}


