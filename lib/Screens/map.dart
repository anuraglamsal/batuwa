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

class Embark extends StatefulWidget{
  @override
  _EmbarkState createState() => _EmbarkState();
}

class _EmbarkState extends State<Embark>{
  Set<Marker> marker_list = new Set(); //This stores all the markers to show on the map.
  String pressed_marker_id; //This stores the id of the marker tapped.
  var marker_data; //This variable consits of the stream that fetches stored locations from firestore.
  var location_data; //This variable consists of the stream that fetches real time location of the user.
  bool marker_tapped = false; //This bool deals with the widgets to show when a marker is tapped.
  double lat; //This stores latitude of the current location of the user.
  double long; //This stores longitude of the current location of the user.
  GoogleMapController _controller; //This allows us to control the map.
  @override
  void dispose(){ //Here, we just unsubscribe from subscribed streams as this frees up memory when the widget is not in use.
    location_data.cancel(); 
    marker_data.cancel();
    super.dispose();
  }
  @override 
  void initState(){
    super.initState();
    location_stream(); //This stream constantly updates the latitude and longitude of the user.
    marker_stream(); //This stream constantly updates marker_list by fetching stored locations in real time.
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
	      onTap: (value){ //This does things when the map is tapped. 'value' has the coordinates of the tapped location on the map.
		//When the map is tapped, I want to remove the widgets to only show when a marker is tapped (tapping on a marker and the map is not same)
		//The 'marker_tapped' widget is used to hide/show the widgets that are related to marker taps.
		setState((){ 
		  marker_tapped = false;
	        });
	      }
	    ),
	  ),
	  Positioned( //This widget deals with moving the map camera to the current coordinates of the user's location.
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
	  Positioned( //This widget deals with routing the user to the page where they save the current location.
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
	  marker_tapped ? 
	      Positioned( //This widget is shown only when a marker is tapped. This widget is used to delete the marker.
		bottom: 260,
		left: 10,
		child: ConstrainedBox(
		  constraints: BoxConstraints.tightFor(width: 70, height: 70),
		  child: ElevatedButton(
		    style: ElevatedButton.styleFrom(
		      shape: CircleBorder(),
		      primary: Colors.red[700],
		    ),
		    child: Icon(Icons.delete, size: 35,),
		    onPressed: (){
		      delete_field(pressed_marker_id);
		      marker_tapped = false;
		    }
		  ),
		),
	      ) : SizedBox(),
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
      marker_list.clear();
      setState((){
	for(MapEntry e in snapshot.data().entries){
	  marker_list.add(
	    Marker(
	      markerId: MarkerId('$e.key'), 
	      position: LatLng(e.value[0], e.value[1]), 
	      onTap: (){
		setState((){
		  pressed_marker_id = e.key;
		  marker_tapped = true;
		});
	      }
	    )
	  );
        }
	/*snapshot.data().forEach((k,v){
	  marker_list.add(
	    Marker(
	      markerId: MarkerId('$k'), 
	      position: LatLng(v[0], v[1]), 
	      onTap: (){
		setState((){
		  marker_tapped = true;
	        });
	      }
          ));
        });*/
      });
    });
  }

  location_stream() {
    location_data = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen((Position _position){
      setState((){
	lat = _position.latitude;
	long = _position.longitude;
      });
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
