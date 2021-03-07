import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Embark extends StatefulWidget{
  @override
  _EmbarkState createState() => _EmbarkState();
}

class _EmbarkState extends State<Embark>{
  double lat;
  double long;
  @override 
  void initState(){
    users_initial_location();
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
	  Expanded(
	    child: GoogleMap(
	      initialCameraPosition: CameraPosition(
		target: LatLng(lat, long),
		zoom: 18,
	      ),
	      markers: <Marker>{
		Marker(
		  markerId: MarkerId('hello'),
		  position: LatLng(lat, long),
		),
	      },	    
	    ),
	  ),
	],
      ),
    );
  }

  users_initial_location() async{
    Position _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState((){
      lat = _position.latitude;
      long = _position.longitude;
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
