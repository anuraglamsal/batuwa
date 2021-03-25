import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Cloud/cloud.dart';
import 'dart:async';
import 'save_location.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Map_Screen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Embark(),
    );
  }
}

class Embark extends StatefulWidget{
  @override
  _EmbarkState createState() => _EmbarkState();
}

class _EmbarkState extends State<Embark>{
  Set<Marker> marker_list = new Set(); //This stores all the markers to show on the map.
  List<LatLng> polyline_points_saving = [];
  List<LatLng> polyline_points = [];
  Set<Polyline> polyline_list = {};
  String pressed_marker_id; //This stores the id of the marker tapped.
  String pressed_polyline_id;
  var marker_data; //This variable consits of the stream that fetches stored locations from firestore.
  var polyline_data;
  var location_data; //This variable consists of the stream that fetches real time location of the user.
  bool marker_tapped = false; //This bool deals with the widgets to show when a marker is tapped.
  bool recording_started = false;
  bool save_route_widgets = false;
  double lat; //This stores latitude of the current location of the user.
  double long; //This stores longitude of the current location of the user.
  GoogleMapController _controller; //This allows us to control the map.
  @override
  void dispose(){ //Here, we just unsubscribe from subscribed streams as this frees up memory when the widget is not in use.
    location_data.cancel(); 
    marker_data.cancel();
    polyline_data.cancel();
    super.dispose();
  }
  @override 
  void initState(){
    super.initState();
    location_stream(); //This stream constantly updates the latitude and longitude of the user.
    marker_stream(); //This stream constantly updates marker_list by fetching stored locations in real time.
    polyline_stream();
  }
  @override
  Widget build(BuildContext context){
    if(lat==null){ //If the latitude variable is null, this means that the 'location_stream' stream is still being subscribed to. Thus, until this 
      	           //happens, we show an indicator.	
      return Container(
	alignment: Alignment.center,
	color: Color(0xff0e0f26),
	child: Container(
	  height: 20,
	  width: 20,
	  child: CircularProgressIndicator(),
	),
      );
    }
    return Container(
      alignment: Alignment.center,
      child: Stack( //Using stack as we want to stack widgets on top of the map.
	children: [
	  SizedBox(height: 50),
	  Container(
	    height: double.infinity, //This fills the entire screen with the map.
	    width: double.infinity, //Same as above.
	    child: GoogleMap(
	      onMapCreated: (GoogleMapController controller){ //We need to provide a method in this way to onMapCreated which in return gives
		//us a "controller" that can be used to control the map.
		_controller = controller;
	      },
	      initialCameraPosition: CameraPosition( //This allows us to show which location is shown when the map is loaded for the first time.
		target: LatLng(lat, long), //We give the current location of the user as the location to show for first-time map load.
		zoom: 18, //This is the zoom level of the map loaded for the first time. 
	      ),
	      myLocationEnabled: true, //This brings a blue circle like thing on the map indicating the current location of the user.
	      myLocationButtonEnabled: false, //This button is enabled on default when "myLocationEnabled" becomes true. But I have manually
	       			              //disabled it here as I had already created a button that does that.
	      markers: marker_list, //This takes in a list of markers to show on the map.
	      polylines: polyline_list,
	      onTap: (value){ //This does things when the map is tapped. 'value' has the coordinates of the tapped location on the map.
		//When the map is tapped, I want to remove the widgets to only show when a marker is tapped (tapping on a marker and the map is not same)
		//The 'marker_tapped' widget is used to hide/show the widgets that are related to marker taps.
		setState((){ 
		  marker_tapped = false;
	        });
	      }
	    ),
	  ),
	  /*Positioned(
	    right: 0,
	    child: FloatingActionButton(
	      onPressed: (){
		FirebaseFirestore.instance.collection('location').doc(
		polyline_points.clear();
		polyline_points.add(
		  Polyline(
		    polylineId: PolylineId("Test",),
		    points: polyline_points,
		    width: 4,
		    color: Colors.purple,
		  ),
		),
	      },
	    ),
	  ),*/
	  Positioned( //This widget deals with moving the map camera to the current coordinates of the user's location.
	    bottom: 100,
	    left: 10,
	    child: ConstrainedBox(
	      constraints: BoxConstraints.tightFor(width: 70, height: 70),
	      child: FloatingActionButton(
		child: Icon(Icons.location_pin, size: 40,),
		onPressed: (){
		  _controller.moveCamera(CameraUpdate.newLatLng(LatLng(lat, long)));//This update's the map's camera to the given latitude and longitude.
		  //The "moveCamera" method takes in either normal methods or static
		  //methods of the "CameraUpdate" class. Static methods are methods
		  //of a class that you access through the class directly, not through an	
		  //object of the class. For example, here, "newLatLng" is a static method
		  //of the "CameraUpdate" class.
		}
	      ),
	    ),
	  ),
	  Positioned( //This widget deals with routing the user to the page where they save the current location.
	    bottom: 180,
	    left: 10,
	    child: ConstrainedBox(
	      constraints: BoxConstraints.tightFor(width: 70, height: 70),
	      child: FloatingActionButton(
		backgroundColor: Colors.purple,
		child: Icon(Icons.save, size: 35,),
		onPressed: (){
		  route_to_save(context, null);
	        }
	      ),
	    ),
	  ),
	  Positioned(
	    bottom: 260,
	    left: 10,
	    child: ConstrainedBox(
	      constraints: BoxConstraints.tightFor(width: 70, height: 70),
	      child: FloatingActionButton(
		backgroundColor: Colors.red,
		child: !recording_started ? Icon(Icons.fiber_manual_record_sharp, size: 35,) : Icon(Icons.stop, size: 35,),
		onPressed:(){
		  setState((){
		    if(recording_started){
		      recording_started = false;
		      save_route_widgets = true;
		      _controller.moveCamera(CameraUpdate.zoomTo(15));
		      //route_to_save(context, polyline_list.first);
		      //polyline_points.clear();
		      //polyline_list.clear();
		    }
		    else{
		      recording_started = true;
		      polyline_list.add(
			Polyline(
			  polylineId: PolylineId("Test",),
			  points: polyline_points_saving,
			  width: 4,
			  color: Colors.purple,
			),
		      );
		    }
		  });
	        },
	      ),
	    ),
	  ),
	  marker_tapped ? 
	      Positioned( //This widget is shown only when a marker is tapped. This widget is used to delete the marker.
		bottom: 340,
		left: 10,
		child: ConstrainedBox(
		  constraints: BoxConstraints.tightFor(width: 70, height: 70),
		  child: FloatingActionButton(
		    child: Icon(Icons.delete, size: 35,),
		    onPressed: (){
		      if(pressed_marker_id == null){
			delete_polyline_field(pressed_polyline_id);
		      }
		      else{
			delete_location_field(pressed_marker_id);
		      }
		      marker_tapped = false;
		    },
		  ),
		),
	      ) : SizedBox(),
	  save_route_widgets ?
	      Positioned(
		bottom: 15,
		left: 21,
		child: Container(
		  height: 50,
		  width: 350,
		  decoration: BoxDecoration(
		    color: Color(0xff9c99ff),
		    borderRadius: BorderRadius.all(Radius.circular(15)),
		  ),
		  child: Row(
		    //mainAxisAlignment: MainAxisAlignment.,
		    children: [
		      SizedBox(width: 23),
		      Text(
			"Do you want to save the path?",
			style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "Mohave"),
		      ),
		      SizedBox(width: 15),
		      Container(
			height: 30, 
			width: 30,
			child: FloatingActionButton(
			  backgroundColor: Colors.green[200],
			  onPressed: (){
			    setState((){
			      save_route_widgets = false;
			    });
			    List<GeoPoint> points = [];
			    for(int i=0; i<polyline_points_saving.length; ++i){
			      points.add(GeoPoint(polyline_points_saving[i].latitude, polyline_points_saving[i].longitude));
			    }
			    route_to_save(context, points);
			  },
		  	  child: Icon(Icons.check,),
		        ),
		      ),
		      SizedBox(width: 15),
		      Container(
			height: 30, 
			width: 30,
			child: FloatingActionButton(
			  backgroundColor: Colors.red[300],
			  onPressed: (){
			    setState((){
			      save_route_widgets = false;
			    });
			  },
			  child: Icon(Icons.close,),
			),
		      ),
		    ],
		  ),
		),
	      ) : SizedBox(),
	    ],
	  ),
	);
      }

  route_to_save(BuildContext context, polyline) async{
    final _result = await Navigator.push( 
      context,
      MaterialPageRoute(builder: (context) => savescreen(lat, long, polyline)),
    );
    //After you pop out of the travelled route, the code below is run to show a dialog box that says "Location Saved"
    if(_result != null){
      return showDialog(context: context, builder: (context){
	return AlertDialog(
	  title: Text("$_result"),
	  actions: [
	    MaterialButton(
	      child: Text("CLOSE"),
	      onPressed: (){
		Navigator.pop(context);
	      },
	    ),
	  ],
	);
      });
    }
  }

  polyline_stream() async{
    polyline_data = FirebaseFirestore.instance.collection('polylines').doc(FirebaseAuth.instance.currentUser.uid).snapshots().listen((snapshot){
      for(MapEntry e in snapshot.data().entries){
	polyline_points.clear();
	for(int i=0; i<e.value.length; ++i){
	  polyline_points.add(LatLng(e.value[i].latitude, e.value[i].longitude));
        }
	polyline_list.add(
	  Polyline(
	    polylineId: PolylineId("$e.key",),
	    points: polyline_points,
	    width: 4,
	    color: Colors.purple,
	    onTap: (){
	      setState((){
		pressed_polyline_id = e.key;
		pressed_marker_id = null;
		marker_tapped = true;
	      });
	    },
	  )
	);
      }
    });
  }

  marker_stream() async{
    marker_data = FirebaseFirestore.instance.collection('location').doc(FirebaseAuth.instance.currentUser.uid).snapshots().listen((snapshot){
      marker_list.clear();
      setState((){
	for(MapEntry e in snapshot.data().entries){
	  marker_list.add(
	    Marker(
	      markerId: MarkerId('$e.key'), 
	      position: LatLng(e.value[0], e.value[1]), 
	      infoWindow: InfoWindow(
		title: e.value[2],
	      ),
	      onTap: (){
		setState((){
		  pressed_marker_id = e.key;
		  marker_tapped = true;
		});
	      }
	    )
	  );
        }
      });
    });
  }

  location_stream() {
    location_data = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen((Position _position){
      setState((){
	lat = _position.latitude;
	long = _position.longitude;
	if(recording_started){
	  polyline_points_saving.add(LatLng(lat, long));
        }
      });
    });
  }

}


