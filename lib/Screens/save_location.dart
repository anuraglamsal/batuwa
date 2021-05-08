import 'package:flutter/material.dart';
//import '../Cloud/cloud.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'save_location_2.dart';

class savescreen extends StatefulWidget{
  //We list the things that are sent when we route to this page from another page. 
  final double lat;
  final double long;
  final List<GeoPoint> polyline;
  const savescreen(this.lat, this.long, this.polyline); //We also need to this for each of the things.
  //Now we can access these things using 'widget.name' inside the class below. The 'name' in 'widget.name' is the name of the things.
  @override
  _savescreenState createState() => _savescreenState();
}

class _savescreenState extends State<savescreen>{
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> formkey_2 = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController ease_of_journey_desc = TextEditingController();
  bool isKeyboardVisible = false;
  bool _visible = true;
  var keyboardvisibilitystream;
  double _rating = 3;
  void dispose(){
    keyboardvisibilitystream.cancel();
    super.dispose();
  }
  void initState(){
    super.initState();
    keyboardvisibilitystream = KeyboardVisibilityController().onChange.listen((bool visible){
      if(!_visible && !visible){
	setState((){
	  _visible = true;
        });
      };
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
	      Visibility(
		child: Column(
		  children: [
		    SizedBox(height: 30),
		    Container(
		      height: 60,
		      width: 370,
		      alignment: Alignment.center,
		      decoration: BoxDecoration(
			color: Color(0xff2c334f),
			borderRadius: BorderRadius.all(Radius.circular(15)),
		      ),
		      child: Text(
			"The name you want to give to this location", 
			textAlign: TextAlign.center,
			style: TextStyle(fontSize: 21, color: Colors.white, fontFamily: 'Mohave',),
		      ),
		    ),
		    Form(
		      key: formkey,
		      child: Container(
			width: 330,
			child:TextFormField(
			  controller: name, 
			  style: TextStyle(color: Colors.white),
			  decoration: InputDecoration(
			    enabledBorder: UnderlineInputBorder(
			      borderSide: BorderSide(color: Color(0xff434a66)),
			    ),
			    focusedBorder: UnderlineInputBorder(
			      borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),	
			    ),
			  ),
			  cursorColor: Colors.blueGrey,
			  validator: (value){  
			    if(value.isEmpty){
			      return "Required"; 
			    }
			  },
			),
		      ),
		    ),
		    SizedBox(height: 30),
		    Container(
		      height: 55,
		      width: 150,
		      alignment: Alignment.center,
		      decoration: BoxDecoration(
			color: Color(0xff2c334f),
			borderRadius: BorderRadius.all(Radius.circular(15)),
		      ),
		      child: Text(
			"Ease of journey", 
			textAlign: TextAlign.center,
			style: TextStyle(fontSize: 21, color: Colors.white, fontFamily: 'Mohave',),
		      ),
		    ),
		    SizedBox(height: 23),
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
		    SizedBox(height: 10),
		    Opacity(
		      opacity: 0.5,
		      child: Text("Relatively near 5 stars = relatively easy", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic,),),
		    ),
		    Opacity(
		      opacity: 0.5,
		      child: Text("Relatively near 1 star = relatively hard", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic,),),
		    ),
		  ],
		),
		maintainState: true,
		visible: _visible,
	      ),
	      SizedBox(height: 22),
	      Text("In terms of description:", style: TextStyle(color: Colors.blue[300],),),
	      SizedBox(height: 23),
	      Form(
		key: formkey_2,
		child: Container(
		  width: 350,
		  child: TextFormField(
		    style: TextStyle(color: Colors.white,),
		    maxLines: 10,
		    controller: ease_of_journey_desc,
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
			_visible = false;
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
	      SizedBox(height: 10),
	      Opacity(
		opacity: 0.5,
		child: Text("Maximum number of characters is 500.", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic,),),
	      ),
	      SizedBox(height: 25),
	      Container(
		height: 42, 
		child: RaisedButton(
		  color: Colors.blue,
		  onPressed: () {
		    /*if(isKeyboardVisible){
		      setState((){
		        isKeyboardVisible = false;
		      });
		    }*/
		    if(formkey.currentState.validate() && formkey_2.currentState.validate()){  
		      //send_location(widget.lat, widget.long, name.text, widget.polyline);
		      Navigator.push(
			context,
			MaterialPageRoute(builder: (context) => save_screen_2(
			  widget.lat,
			  widget.long,
			  ease_of_journey_desc.text,
			  name.text,
			  _rating,
			  widget.polyline,
			)),
		      );
		    }
		    else{
		      if(!_visible){ //The below block is only intended to execute when the widgets above the description box are hidden.
			FocusManager.instance.primaryFocus.unfocus(); //Brings the keyboard down whenever the form where you give name to the location
		                                                      //returns an error. This is done such that the error actually is seen by the user.
		      }
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

    /*send_location(lat, long, name, polyline){
      if(polyline != null){ //When 'polyline' is not null, this means that the user intends to save the polyline.
      save_polyline(polyline); //Thus, we save the polyline.
      save_location(name, lat, long); //We also save the end location.
    }
    else{
      save_location(name, lat, long); //We only save the location if 'polyline' is null.
    }
    Navigator.pop(context, 'Location saved'); //The string beside 'context' here is sent to the route that this route was navigated from.
  }*/

}

