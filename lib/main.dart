import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Routing/homescreen.dart';
import 'Routing/userscreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './Cloud/cloud.dart';
import './Routing/login_stream.dart';

Future<void> main() async{ //You need to initialize the "main" function in this particular manner for Firebase to be initialized.
  WidgetsFlutterBinding.ensureInitialized();//Required to initialize Firebase.
  await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/google-icon.svg'), null); //Caches this svg image such that 
   														//it loads faster throughout the app.
  await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/facebook-icon.svg'), null);
  await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/images/twitter-icon.svg'), null);
  await Firebase.initializeApp();//Same as above.
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){  //Buildcontext describes where you are in the tree of widgets of your application.
    return StreamBuilder( //Learn about 'streams' before proceeding.
      stream: login_stream(), //This stream gives information about whether a user is logged in or not. 
      builder: (context, snapshot){
	if(snapshot.connectionState == ConnectionState.waiting){
	  print(1);
	  return Text("YEP");//replace Text("YEP"); with LinearProgressIndicator(); 
        }
	else{
	  //FirebaseAuth.instance.signOut();
	  //GoogleSignIn().signOut();
	  print(snapshot.data);
	  if(snapshot.data != null){
	    print(snapshot.data);
	    String creationTime = snapshot.data.metadata.creationTime.toString().substring(0,19);
	    print(creationTime);
	    String lastSignInTime = snapshot.data.metadata.lastSignInTime.toString().substring(0,19);
	    if(creationTime == lastSignInTime){
	      firsttimelogin(1);
	    }
	  }
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


