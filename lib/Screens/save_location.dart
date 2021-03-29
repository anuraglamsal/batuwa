import 'package:flutter/material.dart';
import '../Cloud/cloud.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //Package required to use the cloud services of firebase. The package is called cloud firestore.

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
  TextEditingController name = TextEditingController();
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
	    SizedBox(height: 20),
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
	    SizedBox(height: 15),
	    Container(
	      height: 42, 
	      child: RaisedButton(
		color: Color(0xff2c334f),
		onPressed: () {
		  if(formkey.currentState.validate()){  
		    send_location(widget.lat, widget.long, name.text, widget.polyline);
		  }
		},
		child: Text(
		  "Save",
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

  send_location(lat, long, name, polyline){
    if(polyline != null){ //When 'polyline' is not null, this means that the user intends to save the polyline.
      save_polyline(polyline); //Thus, we save the polyline.
      save_location(name, lat, long); //We also save the end location.
    }
    else{
      save_location(name, lat, long); //We only save the location if 'polyline' is null.
    }
    Navigator.pop(context, 'Location saved'); //The string beside 'context' here is sent to the route that this route was navigated from.
  }

}

