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
  /*var _onpressed = (){
    upload_to_db();
  };*/
  bool circle = false;
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
	    SizedBox(height: 20),
	    circle ?
	    CircularProgressIndicator(
	      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff07B0B5)),
	    ) :
	    Container(
	      height: 35, 
	      width: 80,
	      child: ElevatedButton(
		onPressed: (_image != null) ? (() => upload_to_db()) : null,
		child: Text(
		  "NEXT",
		),
		style: ButtonStyle(
		  backgroundColor: MaterialStateProperty.resolveWith<Color>(
		    (Set<MaterialState> states) {
		      if (states.contains(MaterialState.pressed))
			return Color(0xff07B0B5); //On pressed color
		      else if (states.contains(MaterialState.disabled))
			return Color.fromRGBO(7, 176, 181, 0.2); //Disabled color
		      return Color(0xff07B0B5); //Enabled color
		    },
		  ), 
		),
	      ),
	    ),
	    SizedBox(height: 256.5),
	    Material(
	      color: Colors.transparent,
	      child: InkWell(
		customBorder: CircleBorder(),
		child: Container(
		  width: 60,
		  child: Row(
		    children :[
		      SizedBox(width: 10),
		      Text(
			"Skip",
			style: TextStyle(color: Color(0xff757575),),
		      ),
		      Icon(
			Icons.skip_next,
			color: Color(0xff757575),
			size: 22,
		      ),
		    ],
		  ),
		),
		onTap: (){
		  route_to_feed();
		},
	      ),
	    ),
	  ],
	),
      ),
    );
  }

  route_to_feed() async{
    await update_token(0);
    Navigator.pop(context);
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
  
  upload_to_db() async{
    setState((){
      circle = true;
    });
    await firebase_storage.FirebaseStorage.instance.ref('ProfPic/' + FirebaseAuth.instance.currentUser.uid).putFile(_image);
    String dwnldurl = await firebase_storage.FirebaseStorage.instance.ref('ProfPic/' + FirebaseAuth.instance.currentUser.uid).getDownloadURL();
    await save_image_url(dwnldurl);
    route_to_feed();
  }

}


