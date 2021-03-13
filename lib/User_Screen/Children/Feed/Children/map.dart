import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'save.dart';

class Embark extends StatefulWidget{
  @override
  _EmbarkState createState() => _EmbarkState();
}

class _EmbarkState extends State<Embark>{
  Set<Marker> marker_list = new Set();
  var marker_data;
  var location_data;
  double lat;
  double long;
  GoogleMapController _controller;
  @override
  void dispose(){
    location_data.cancel();
    marker_data.cancel();
    super.dispose();
  }
  @override 
  void initState(){
    super.initState();
    users_location();
    location_stream();
    marker_stream();
  }
  @override
  Widget build(BuildContext context){
    if(lat==null){
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
      child: Stack(
	children: [
	  SizedBox(height: 50),
	  Container(
	    height: double.infinity,
	    width: double.infinity,
	    child: GoogleMap(
	      onMapCreated: (GoogleMapController controller){ //We need to provide a method in this way to onMapCreated which in return gives
		//us a "controller" that can be used to control the map until it is active after 
		//its creation. 
		_controller = controller;
	      },
	      initialCameraPosition: CameraPosition(
		target: LatLng(lat, long),
		zoom: 18,
	      ),
	      markers: marker_list, 
	    ),
	  ),
	  Positioned(
	    bottom: 100,
	    left: 10,
	    child: ConstrainedBox(
	      constraints: BoxConstraints.tightFor(width: 70, height: 70),
	      child: ElevatedButton(
		style: ElevatedButton.styleFrom(
		  shape: CircleBorder(),
		  primary: Colors.blue,
		),
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
	  Positioned(
	    bottom: 180,
	    left: 10,
	    child: ConstrainedBox(
	      constraints: BoxConstraints.tightFor(width: 70, height: 70),
	      child: ElevatedButton(
		style: ElevatedButton.styleFrom(
		  shape: CircleBorder(),
		  primary: Colors.purple,
		),
		child: Icon(Icons.save, size: 35,),
		onPressed: (){
		  route_to_save(context);
	        }
	      ),
	    ),
	  ),
	],
      ),
    );
  }

  route_to_save(BuildContext context) async{
    final _result = await Navigator.push( 
      context,
      MaterialPageRoute(builder: (context) => savescreen(lat, long)),
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

  marker_stream() async{
    marker_data = FirebaseFirestore.instance.collection('location').doc(FirebaseAuth.instance.currentUser.uid).snapshots().listen((snapshot){
      setState((){
	snapshot.data().forEach((k,v){
	  marker_list.add(
	    Marker(
	      markerId: MarkerId('$k'), 
	      position: LatLng(v[0], v[1]), 
	      onTap: (){
	      }
          ));
        });
      });
    });
  }

  users_location() async{
    Position _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(_position);
    setState((){
      lat = _position.latitude;
      long = _position.longitude;
    });
  }

  location_stream() {
    location_data = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen((Position _position){
      if(_position.latitude >= lat+0.00001 || _position.latitude <= lat-0.00001){
	setState((){
	  lat = _position.latitude;
	  long = _position.longitude;
	});
      }
    });
  }

}

/*class _EmbarkState extends State<Embark>{
  @override
  void dispose(){
    location_data.cancel();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    users_initial_location_in_map();
    real_time_marker_change();
  }
  @override
  Widget build(BuildContext context){
    if(position == null){
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
    else{
      return Container(
	alignment: Alignment.center,
	child: Stack(
	  children: [
	    InteractiveViewer(
	      child: Container(
		width: 500,
		child: FlutterMap(
		  mapController: mapController,
		  options: MapOptions(
		    center: LatLng(position.latitude, position.longitude),
		    zoom: 17.4,
		    maxZoom: 22.0,
		  ),
		  layers: [
		    TileLayerOptions(
		      urlTemplate: 'http://mt{s}.google.com/vt/lyrs=m@221097413,parking,traffic,lyrs=m&x={x}&y={y}&z={z}',
		      maxZoom: 24.0,
		      subdomains: ['0', '1', '2', '3'],
		      retinaMode: true,
		    ),
		    MarkerLayerOptions(
		      markers: [
			Marker(
			  width: 80.0,
			  height: 80.0,
			  point: LatLng(position.latitude, position.longitude),
			  builder: (ctx) =>
			  Container(
			    child: Icon(Icons.location_pin, size: 50, color: Colors.blue[600],),
			  ),
			),
			Marker(
			  width: 80.0,
			  height: 80.0,
			  point: LatLng(position.latitude - 0.001, position.longitude - 0.001),
			  builder: (ctx) =>
			  Container(
			    child: Icon(Icons.location_pin, size: 50, color: Colors.blue[600],),
			  ),
			),
		      ],
		    ),
		  ],
		),
	      ),
	    ),
	    Positioned(
	      bottom: 50,
	      right: 10,
	      child: Container(
		width: 60,
		height: 60,
		child: ElevatedButton(
		  style: ElevatedButton.styleFrom(
		    shape: CircleBorder(),
		    primary: Colors.blue,
		  ),
		  child: Icon(Icons.location_searching,),
		  onPressed: (){
		    move_map_camera_to_user();
		  },
		),
	      ),
	    ),
	  ],
	),
      );
    }
  }

  users_initial_location_in_map() async{
    Position _position = await get_users_location();
    setState((){
      position = _position;
    });
  }

  real_time_marker_change(){
    location_data = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen((Position _position){
      setState((){
	position = _position;
      });
    });
  }

  move_map_camera_to_user() async{
    Position _position = await get_users_location();
    mapController.move(
      LatLng(_position.latitude, _position.longitude),
      20,
    );
  }

  Future<Position> get_users_location() async{
    Position _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return _position;
  }

}*/
