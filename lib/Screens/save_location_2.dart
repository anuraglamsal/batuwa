import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'save_location_3.dart';

class save_screen_2 extends StatefulWidget{
  final double lat;
  final double long;
  final String ease_desc;
  final String name;
  final double ease_rating;
  final List<GeoPoint> polyline;
  const save_screen_2(this.lat, this.long, this.ease_desc, this.name, this.ease_rating, this.polyline);
  @override
  _save_screen_2State createState() => _save_screen_2State();
}

class _save_screen_2State extends State<save_screen_2>{
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController general_enjoy = TextEditingController();
  double _rating = 2.5;
  var keyboardvisibilitystream;
  bool isKeyboardVisible = false;
  void dispose(){
    keyboardvisibilitystream.cancel();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    keyboardvisibilitystream = KeyboardVisibilityController().onChange.listen((bool visible){
      if(isKeyboardVisible && !visible){
	setState((){
	  isKeyboardVisible = false;
        });
      };
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
	title: Container(
	  alignment: Alignment(-0.2, 0),
	  child: Text(
	    "batuwa",
	    style: TextStyle(
	      fontFamily: 'Mohave',
	    ),
	  ),
	),
	backgroundColor: Color(0xff252a42),
      ),
      body: Container(
	alignment: Alignment.center,
	color: Color(0xff0e0f26),
	child: Column(
	  children: [
	    !isKeyboardVisible ? Column(
	      children: [
		SizedBox(height: 30),
		Container(
		  height: 57,
		  width: 300,
		  alignment: Alignment.center,
		  decoration: BoxDecoration(
		    color: Color(0xff2c334f),
		    borderRadius: BorderRadius.all(Radius.circular(15)),
		  ),
		  child: Text(
		    "General Enjoyment of the location", 
		    textAlign: TextAlign.center,
		    style: TextStyle(fontSize: 21, color: Colors.white, fontFamily: 'Mohave',),
		  ),
		),
		SizedBox(height: 19),
		Text("In terms of rating:", style: TextStyle(color: Colors.blue[300],),),
		SizedBox(height: 15),
		RatingBar.builder(
		  initialRating: 2.5,
		  minRating: 1,
		  direction: Axis.horizontal,
		  allowHalfRating: true,
		  itemCount: 5,
		  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
		  itemBuilder: (context, _) => Icon(
		    Icons.star,
		    color: Colors.blue,
		  ),
		  unratedColor: Colors.blueGrey[100],
		  onRatingUpdate: (rating) {
		    print(rating);
		    _rating = rating;
		  },
		),
	      ],
	    ) : SizedBox(),
	    SizedBox(height: 19),
	    Text("In terms of description:", style: TextStyle(color: Colors.blue[300],),),
	    SizedBox(height: 23),
	    Form(
	      key: formkey,
	      child: Container(
		width: 350,
		child: TextFormField(
		  style: TextStyle(color: Colors.white,),
		  maxLines: 10,
		  controller: general_enjoy, 
		  decoration: InputDecoration(
		    enabledBorder: OutlineInputBorder(
		      borderSide: BorderSide(
			color: Color(0xff434a66),
		      ),
		    ),
		    focusedBorder: OutlineInputBorder(
		      borderSide: BorderSide(
			color: Colors.blueGrey,
		      ),
		    ),
		  ),
		  onTap: (){
		    setState((){
		      isKeyboardVisible = true;
		    });
		  },
		  cursorColor: Colors.blueGrey,
		  validator: (value){
		    if(value.length > 500){
		      return "The maximum number of characters is 500!";
		    }
		  }
		),
	      ),
	    ),
	    SizedBox(height: 25),
	    Container(
	      height: 42, 
	      child: RaisedButton(
		color: Colors.blue,
		onPressed: () {
		  if(formkey.currentState.validate()){  
		    Navigator.push(
		      context,
		      MaterialPageRoute(builder: (context) => save_screen_3(
			widget.lat,
			widget.long,
			widget.ease_desc,
			widget.name,
			widget.ease_rating,
			widget.polyline,
			_rating,
			general_enjoy.text,
		      )),
		    );
		  }
		},
		child: Text(
		  "Next",
		  style: TextStyle(fontSize: 18.7, color: Colors.white, fontFamily: 'Mohave'),
		),
		shape: RoundedRectangleBorder(
		  borderRadius: BorderRadius.circular(10.0),
		),
	      ),
	    ),
	  ],
	),
      ),
    );
  }
}


