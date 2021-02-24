import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Embark extends StatefulWidget{
  @override
  _EmbarkState createState() => _EmbarkState();
}

class _EmbarkState extends State<Embark>{
  Position position;
  StreamSubscription location_data;
  MapController mapController = MapController();
  @override
  void dispose(){
    location_data.cancel();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    getCurrentLocation();
    move_map();
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
	child: Stack(
	  children: [
	    FlutterMap(
	      mapController: mapController,
	      options: MapOptions(
		center: LatLng(position.latitude, position.longitude),
		zoom: 17.0,
	      ),
	      layers: [
		TileLayerOptions(
		  urlTemplate: 'http://mt{s}.google.com/vt/lyrs=m@221097413,parking,traffic,lyrs=m&x={x}&y={y}&z={z}',
		  maxZoom: 22.0,
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
			child: FlutterLogo(),
		      ),
		    ),
		  ],
		),
	      ],
	    ),
	    Positioned(
	      bottom: 100,
	      right: 80,
	      child: ElevatedButton(
		child: Text("MY LOCATION"),
		onPressed: (){
		  click_button();
	        },
	      ),
	    ),
	  ],
	),
      );
    }
  }

  void getCurrentLocation() async{
    Position _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState((){
      position = _position;
    });
  }

  move_map(){
    location_data = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen((Position _position){
      setState((){
	position = _position;
      });
    });
  }

  click_button() async{
    Position _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    mapController.move(
      LatLng(_position.latitude, _position.longitude),
      20,
    );
  }

}
