import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

class profpicscreen extends StatefulWidget{
  @override
  _profpicscreenState createState() => _profpicscreenState();
}

class _profpicscreenState extends State<profpicscreen>{
  String imageUrl;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
	title: Center(child: Text("batuwa", style: TextStyle(fontFamily: 'Mohave',))),
	backgroundColor: Color(0xff252a42),
      ),
      body: Container(
	color: Color(0xff0e0f26),
	alignment: Alignment.center,
	child: Column(
	  children: [
	    SizedBox(height: 30),
	    (imageUrl !=null) ?
	    	Image.network(imageUrl) :
		CircleAvatar(
		  radius: 50,
		  backgroundColor: Color(0xff252a42),
		  backgroundImage: AssetImage(
		    'assets/images/ProfilePic.png',
		  ),
		),
            SizedBox(height: 30),	
	    Container(
	      height: 50,
	      width: 210,
	      child: ElevatedButton(
		style: ElevatedButton.styleFrom(
		  primary: Color(0xff252a42),
		),
		onPressed: (){},
		child: Text("Upload your profile pic", style: TextStyle(fontFamily: "Mohave", fontSize: 20,)),
	      ),
	    ),
	  ],
	),
      ),
    );
  }

  uploadImage(){

  }

}


