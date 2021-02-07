import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud.dart';
import 'connection.dart';
import 'null_check.dart';

class userscreen extends StatelessWidget{
  @override
  Widget build(BuildContext build){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('token').doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
      builder: (context, snapshot){
	if(snapshot.connectionState == ConnectionState.waiting){
	  return Container();
        }
	else{
	  print(snapshot.data['token']);
	  /*if(snapshot.data['token'] == 1){
	    return firsttimeLogin();
	  }
	  else{
	    return normalscreen();
	  }*/
	  return Scaffold(
	    appBar: AppBar(
	      title: Center(child: Text("batuwa", style: TextStyle(fontFamily: 'Mohave',))),
	      backgroundColor: Color(0xff252a42),
	    ),
	    body: Container(
	      alignment: Alignment.center,
	      color: Color(0xff0e0f26),
	      child:(snapshot.data['token'] == 1) ? firsttimeLogin() : normalscreen(),
	    ),
	  );
        }
      },
    );
  }
}

  
class firsttimeLogin extends StatefulWidget{
  @override
  _firsttimeLoginState createState() => _firsttimeLoginState();
}

class _firsttimeLoginState extends State<firsttimeLogin>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
	SizedBox(height: 50),
	Image.asset('assets/images/logo.png', width: 300, height: 150),
	Container(
	  height: 70,
	  width: 300,
	  alignment: Alignment.center,
	  decoration: BoxDecoration(
	    color: Color(0xff2c334f),
	    borderRadius: BorderRadius.all(Radius.circular(15)),
	  ),
	  child: Text(
	    "Welcome to batuwa", style: TextStyle(color: Colors.white, fontFamily: 'Mohave', fontSize: 33,),
	  ),
	),
	SizedBox(height: 25),
	GestureDetector(
	  child: Container(
	    height: 50,
	    width: 250,
	    alignment: Alignment.center,
	    decoration: BoxDecoration(
	      color: Colors.blue[600],
	      borderRadius: BorderRadius.all(Radius.circular(15)),
	    ),
	    child: Text(
	      "Start posting right away", style: TextStyle(color: Colors.white, fontFamily: 'Mohave', fontSize: 22,),
	    ),
	  ),
	  onTap: (){
	    update_token();
	  },
	),
	SizedBox(height: 17),
	Text(
	  "or", style: TextStyle(fontSize: 17, color: Colors.white),
	),
	SizedBox(height: 17),
	Container(
	  height: 50,
	  width: 250,
	  alignment: Alignment.center,
	  decoration: BoxDecoration(
	    color: Colors.blue[600],
	    borderRadius: BorderRadius.all(Radius.circular(15)),
	  ),
	  child: Text(
	    "Customize your account", style: TextStyle(color: Colors.white, fontFamily: 'Mohave', fontSize: 22,),
	  ),
	),
      ],
    );
  }
}

class normalscreen extends StatefulWidget{
  @override
  _normalscreenState createState() => _normalscreenState();
}

class _normalscreenState extends State<normalscreen>{
  @override
  Widget build(BuildContext context){
    //final check = Provider.of<Connection_1>(context);//We are also connecting this widget to "MyApp". You have to use the same variable firsttimelogin11xx.
    return Column(
      children: <Widget>[
	SizedBox(height: 20),
	RaisedButton(
	  child: Text(
	    'Logout',
	  ),
	  onPressed:(){
	    logout();
	    /*Future.delayed(const Duration(milliseconds: 500), (){ //This is because we encounter syncing problems as signing out takes a bit of time.
	      check.logged = false;
	    });*/
	  }
	)
      ],
    );
  }
  Future<void> logout() async{ //Signs the user out.
    await auth.signOut();
  }
}







