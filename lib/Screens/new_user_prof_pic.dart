import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../Cloud/cloud.dart';
import 'package:image_cropper/image_cropper.dart';

class profpicscreen extends StatefulWidget{
  @override
  _profpicscreenState createState() => _profpicscreenState();
}

class _profpicscreenState extends State<profpicscreen>{
  String imageUrl;
  bool indicator = false;
  bool next = false;
  var _image;
  @override
  void initState(){ //This function is run before the widget is built.
    super.initState();
    /*setState((){
      indicator = true;
    });*/
    //getImageUrl();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
	elevation: 0,
	leading: BackButton(
	  color: Colors.black,
	),
	title: Container(
	  alignment: Alignment(-0.26, 0),
	  child: Text("batuwa", style: TextStyle(color: Colors.black, fontFamily: 'Mohave',),),
	),
	backgroundColor: Color(0xffffffff),
      ),
      backgroundColor: Color(0xffffffff),
      body: Container(
	alignment: Alignment.center,
	child: Column(
	  children: [
	    SizedBox(height: 19),
	    Container(
	      width: 198,
	      child: Text(
		"Upload your desired profile picture",
		style: TextStyle(
		  fontSize: 13,
		  color: Color(0xffa8a8a8),
		),
	      ),
	    ),
	    SizedBox(height: 15),
	    GestureDetector(
	      onTap: (){
		uploadImage();
	      },
	      child: Stack(
		children: [
		  CircleAvatar(
		    radius: 50.7,
		    backgroundColor: Colors.grey,
		    child: CircleAvatar(
		      radius: 50,
		      backgroundColor: Color(0xff07B0B5),
		      backgroundImage: (_image == null) ? AssetImage(
			'assets/images/profpic2.png',
		      ) : FileImage(_image,),
		    ),
		  ),
		  Positioned(
		    bottom: 0,
		    right: 10,
		    child: CircleAvatar(
		      radius: 12.7,
		      backgroundColor: Colors.grey,
		      child: CircleAvatar(
			radius: 12,
			backgroundColor: Color(0xffffffff),
			child: Icon(Icons.edit, size: 19, color: Colors.black),
		      ),
		    ),
		  ),
		],
	      ),
	    ),
	    SizedBox(height: 30),	
	    SizedBox(height: 300),	
	    Row(
	      children: [
		SizedBox(width: 255),
		next ?
	          Container(
		    height: 45,
		    child: ElevatedButton(
		      onPressed: (){
			update_token(0);
		      },
		      child: Text("Go to your feed", style: TextStyle(fontFamily: "Mohave", fontSize: 18),),
		    )
		  ) :
		  SizedBox(),
	      ],
	    ),
	  ],
	),
      ),
    );
  }

  uploadImage() async{ //Read the 'Flutter cloud storage' docs and watch this video: https://www.youtube.com/watch?v=pvRpzyBYBbA to understand this.
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState((){
      if(pickedFile != null){
	cropImage(pickedFile);
      }
    });
  }

  cropImage(pickedFile) async{
    File cropped = await ImageCropper.cropImage(sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    if(cropped != null){
      setState((){
	_image = cropped;
      });
    }
  }

  /*getImageUrl() async{//This gets the profile picture associated with the logged in user. To fully understand this, read this doc: 
    		      //https://firebase.flutter.dev/docs/storage/usage.
    bool flag = true;
    try{
      imageUrl = await firebase_storage.FirebaseStorage.instance.ref('ProfPic/${FirebaseAuth.instance.currentUser.uid.toString()}').getDownloadURL();
      //'The "FirebaseAuth.instance.currentUser.uid" method fetches the unique user id of the logged in user.
    }
    catch(e){
      flag = false;
      setState((){//The widget is rebuilt when the url for the profile image is fetched.
	indicator = false;
	next = false;
      });
    }
    if(flag){
      save_image_url(imageUrl);
      setState((){
	indicator = false;
	next = true;
      });
    }
  }*/

}


