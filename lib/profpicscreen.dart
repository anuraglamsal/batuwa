import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class profpicscreen extends StatefulWidget{
  @override
  _profpicscreenState createState() => _profpicscreenState();
}

class _profpicscreenState extends State<profpicscreen>{
  String imageUrl;
  bool indicator = false;
  @override
  void initState(){
    super.initState();
    getImageUrl();
  }
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
	    (imageUrl != null) ?
		CircleAvatar(
		  radius: 50,
		  backgroundColor: Color(0xff252a42),
		  backgroundImage: NetworkImage(imageUrl),
		) :
		CircleAvatar(
		  radius: 50,
		  backgroundColor: Color(0xff252a42),
		  backgroundImage: AssetImage(
		    'assets/images/ProfilePic.png',
		  ),
		),
            SizedBox(height: 30),	
	    indicator ?
	        CircularProgressIndicator(
		  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
		) : 
		Container(
		  height: 50,
		  width: 210,
		  child: ElevatedButton(
		    style: ElevatedButton.styleFrom(
		      primary: Color(0xff252a42),
		    ),
		    onPressed: (){
		      setState((){
			indicator = true;
		      });
		      uploadImage();
		    },
		    child: Text("Upload your profile pic", style: TextStyle(fontFamily: "Mohave", fontSize: 20,)),
		  ),
		),
	  ],
	),
      ),
    );
  }

  uploadImage() async{
    final _storage = firebase_storage.FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if(permissionStatus.isGranted){
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if(image != null){
	var snapshot = await _storage.ref()
	    .child('ProfPic/${FirebaseAuth.instance.currentUser.uid.toString()}')
	    .putFile(file);
	await getImageUrl();
	print(imageUrl);
	setState((){
	  indicator = false;
        });
      }
    }
  }

  getImageUrl() async{
    imageUrl = await firebase_storage.FirebaseStorage.instance.ref('ProfPic/${FirebaseAuth.instance.currentUser.uid.toString()}').getDownloadURL();
    setState((){
    });
  }

}


