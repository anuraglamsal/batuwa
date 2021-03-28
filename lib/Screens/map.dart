import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Cloud/cloud.dart';
import 'dart:async';
import 'save_location.dart';

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
  Set<Marker> marker_list = {}; //This stores all the markers to show on the map.
  List<LatLng> polyline_points = []; //This stores the polyline points related to the user's path when recording of the path is going on.   
  Set<Polyline> polyline_list = {}; //This stores the actual polylines themselves to show on the map. 
  String pressed_marker_id; //This stores the id of the marker tapped.
  String pressed_polyline_id; //This stores the id of the polyline tapped.
  var marker_data; //This variable consits of the stream that fetches stored locations from firestore.
  var polyline_data; //This variable consists of the stream that fetches stored polyline points from firestore.
  var location_data; //This variable consists of the stream that fetches real time location of the user.
  bool marker_tapped = false; //This bool deals with the widgets to show when a marker is tapped.
  bool recording_started = false; //This bool is 'true' if the user is recording their path.
  bool recording_just_finished = false; //This bool deals with the widgets to show when recording of the user's path has finished. 
  double lat; //This stores latitude of the current location of the user when the map is being loaded. 
  double long; //This stores longitude of the current location of the user when the map is being loaded. 
  double saving_lat; //This stores latitude of the location of the user where they stopped recording their path.
  double saving_long; //This stores longitude of the location of the user where they stopped recording their path.
  GoogleMapController _controller; //This variable allows us to control the map once we receive the 'controller' from 'onMapCreated' in 'GoogleMap'.
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
    polyline_list.add( //We add the polyline that is to be used to show the user's path.
      Polyline(
	polylineId: PolylineId("Test",),
	points: polyline_points, 
	width: 4,
	color: Colors.purple,
      )
    );
    //location_stream(); //This stream constantly updates the latitude and longitude of the user.
    location_for_initial_load(); //This function updates the 'lat' and 'long' variables with the location of the user.
    marker_stream(); //This stream constantly updates 'marker_list' by fetching data each time some change is made in the database where marker
                     //information is stored. 
    polyline_stream(); //This stream does the same as 'marker_stream' but for polylines.
  }
  @override
  Widget build(BuildContext context){
    if(lat == null){ //If the 'lat' variable is null, this means that the 'fetch_user_location' function is still yet to receive the current
                     //location of the user. Thus, until this happens, we show an indicator. 
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
		_controller = controller; //We update the '_controller' variable by giving it 'controller'. Now, we can use '_controller'
		                          //anywhere in this widget to control the map.
	      },
	      initialCameraPosition: CameraPosition( //This allows us to show which location is shown when the map is loaded for the first time.
		target: LatLng(lat, long), //We give the coordinates of the location to show for first-time-map-load. 
		zoom: 18, //This is the zoom level of the map loaded for the first time. 
	      ),
	      myLocationEnabled: true, //This brings a blue circle like thing on the map indicating the current location of the user.
	      myLocationButtonEnabled: false, //This button is enabled by default when 'myLocationEnabled' becomes true. But I have manually
	       			              //disabled it here as I had already created a button that does that.
	      markers: marker_list, //This takes in a list of markers to show on the map.
	      polylines: polyline_list, //This takes in a list of polylines to show on the map.
	      onTap: (value){ //This does things when the map is tapped. 'value' has the coordinates of the tapped location on the map.

		//When the map is tapped, I want to remove the widgets to only show when a marker is tapped.
		//The 'marker_tapped' widget is used to hide/show the widgets that are related to marker taps.
		setState((){ 
		  marker_tapped = false;
	        });
	      }
	    ),
	  ),

	  Positioned( 
	    bottom: 100,
	    left: 10,
	    child: ConstrainedBox(
	      constraints: BoxConstraints.tightFor(width: 70, height: 70),
	      child: FloatingActionButton( //This button deals with moving the map camera to the current coordinates of the user's location.
		child: Icon(Icons.location_pin, size: 40,),
		onPressed: (){
		  move_camera_to_current_location(); //This function does the moving.
		}
	      ),
	    ),
	  ),

	  Positioned( 
	    bottom: 180,
	    left: 10,
	    child: ConstrainedBox(
	      constraints: BoxConstraints.tightFor(width: 70, height: 70),
	      child: FloatingActionButton( //This button deals with routing the user to the page where they save the current location.
		backgroundColor: Colors.purple,
		child: Icon(Icons.save, size: 35,),
		onPressed: (){
		  route_to_save_location_only(context); //This function does the routing.
	        }
	      ),
	    ),
	  ),

	  Positioned(
	    bottom: 260,
	    left: 10,
	    child: ConstrainedBox(
	      constraints: BoxConstraints.tightFor(width: 70, height: 70),
	      child: FloatingActionButton( //This button 'starts' or 'stops' the recording depending upon what is going on.
		backgroundColor: Colors.red,
		child: !recording_started ? Icon(Icons.fiber_manual_record_sharp, size: 35,) : Icon(Icons.stop, size: 35,), //Different icons
		//depending upon if 'recording' is going on or not.
		onPressed:(){
		  setState((){
		    if(recording_started){ //When the a user presses the button when 'recording_started' is true, it means that they want to stop 
		                           //the recording.
		      recording_started = false; //Because of the reason above, this variable is changed to false to remove all the changes made
		                                 //when recording was going on.
		      location_data.cancel(); //This stops the stream that constantly updates user location that is used to draw polylines in real time.
		      recording_just_finished = true; //This variable is used to show widgets that are supposed to be shown when a recording just 
		                                      //finishes i.e. the user just stopped recording.
		      recording_stopped_location(); //This function saves the location right after recording is stopped so that if the user
		                                    //chooses to save the polyline, the end location is also saved. 
		      _controller.moveCamera(CameraUpdate.zoomTo(17));//The map's zoom level changes in hopes to show more of the polyline if the user
		                                                      //was zooming in hopes that it'll be useful to the user to make their decision
		                			              //in regards to saving the polyline or not. 	
		    }
		    else{
		      recording_started = true; //When the user pressed the button when 'recroding_started' is false, that means that the user
		                                //wants to start the recording. Thus, this becomes true in order to add stuff pertaining to the
		                                //recording. 
		      location_stream(); //This constantly updates user location such that polyline drawing is possible. 
		    }
		  });
	        },
	      ),
	    ),
	  ),

	  marker_tapped ? 
	      Positioned( //This widget is shown only when a marker is tapped. 
		bottom: 340,
		left: 10,
		child: ConstrainedBox(
		  constraints: BoxConstraints.tightFor(width: 70, height: 70),
		  child: FloatingActionButton( //This button deletes a widget if clicked. 
		    child: Icon(Icons.delete, size: 35,),
		    onPressed: (){
		      if(pressed_marker_id == null){ //I am reusing the widget that I initially created to delete markers to also delete polylines. 
			                             //Thus, I have this if statement to see what am I actually supposed to delete. 'pressed_marker_id'
		                                     //being null means that I'm actually supposed to delete a polyline and vice-versa.	
			delete_polyline_field(pressed_polyline_id); //This function does the deleting of polylines. The implementation is in
			                                            //'cloud.dart'.
		      }
		      else{
			delete_location_field(pressed_marker_id); //This functions does the deleting of markers. The implementation is in 'cloud.dart'.
		      }
		      marker_tapped = false; //It makes sense to remove the delete button after the deletion is completed. 
		    },
		  ),
		),
	      ) : SizedBox(),

	  recording_just_finished ?
	      Positioned( //This widget is shown when the user just finished recording their path. 
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
			child: FloatingActionButton( //This button routes you to the 'save_location' screen when the user agrees to save the polyline.
			  backgroundColor: Colors.green[200],
			  onPressed: (){
			    List<GeoPoint> points = []; //Creating a list of 'GeoPoints' for the reasons given below.
			    for(int i=0; i< polyline_points.length; ++i){ //As I thought it was easier to store the points of a polyline
			      //in Firebase as an instance of the 'GeoPoint' class, I am converting all the points of the supposed to be saved
			      //polyline to 'GeoPoint' instances. I am storing each of those instances in the above 'points' list. 
			      points.add(GeoPoint(polyline_points[i].latitude, polyline_points[i].longitude));
			    }
			    setState((){
			      polyline_points.clear(); //We clear the 'polyline_points' list so that the list is empty for the next recording. 
			      recording_just_finished = false; //This gets rid of the widgets to show just after recording has been finished
			                                       //as all the work related to it has been done basically.
			    });
			    route_to_save(context, points, saving_lat, saving_long); //This routes us to the 'save_location' screen with the 
			       							     //polyline points and the locations 	
			  },
		  	  child: Icon(Icons.check,),
		        ),
		      ),

		      SizedBox(width: 15),

		      Container(
			height: 30, 
			width: 30,
			child: FloatingActionButton( //This button primarily removes the widget shown on screen when recording just finished. 
			  backgroundColor: Colors.red[300],
			  onPressed: (){
			    setState((){
			      polyline_points.clear(); //Same reasons as in the 'setState' of the above button. 
			      recording_just_finished = false; 
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

  route_to_save_location_only(BuildContext context) async{ //read linearly from the start of this widget class to understand the context of this function.
    Position position = await fetch_user_location(); //updating the 'lat' and 'long' variables. 
    route_to_save(context, null, position.latitude, position.longitude); 
                                             //This function does the routing. We provide 'null' to 'polyline' parameter of this method
		   		 	     //as we are only saving a location using this button, not a polyline along with a location.
  }

  recording_stopped_location() async{
    Position position = await fetch_user_location();
    setState((){ //Saving the location just after recording is finished if the user wishes to save it later.   
      saving_lat = position.latitude;
      saving_long = position.longitude;
    });
  } 

  route_to_save(BuildContext context, polyline, lati, longi) async{ //This function routes us to the 'save_location' page. 
    final _result = await Navigator.push( 
      context,
      MaterialPageRoute(builder: (context) => savescreen(lati, longi, polyline)), //We send the things that are supposed to be saved which are
                                                                                  //evidently going to be latitude, longitude and polyline if intended.
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
      polyline_list.removeWhere((Polyline polyline) => polyline.polylineId.value != "Test"); //Here, we delete everything else
      //but the polyline that is associated with showing the path that the user is recording. We do so because we don't want updates
      //coming from the stream to hamper any recording if going on. We'll then fill the list again with updated polylines. 
      for(MapEntry e in snapshot.data().entries){ //Iterating through each polyline stored in Firebase. 
	List<LatLng> points = []; //This list stores the polyline points for each polyline stored in Firebase.
	for(int i=0; i<e.value.length; ++i){
	  points.add(LatLng(e.value[i].latitude, e.value[i].longitude)); //We store each individual points in 'points' 
	   								 //for the current polyline in the iteration.
        }
	polyline_list.add( //We create a polyline in the app for each polyline stored in Firebase, so that the polylines actually appear on screen. 
	                   //For that, we store them in 'polyline_list'. 
	  Polyline(
	    polylineId: PolylineId("$e.key",),
	    consumeTapEvents: true,
	    points: points,
	    width: 9,
	    color: Colors.purple,
	    onTap: (){
	      setState((){
		pressed_polyline_id = e.key; //When a polyline is tapped, we want to store the id of that polyline in 'pressed_polyline_id' so 
		                             //that deletion is possible.
		pressed_marker_id = null; //We make this null so that we go to the place where polylines are deleted and not markers when 
		                          //we press the 'delete' button that comes up when we press this polyline. 
		marker_tapped = true; //We make this true to show the widget that is used to delete the polyline.
	      });
	    },
	  )
	);
      }
      setState((){ //Rebuild such that the changes in Firebase translate to the changes on screen. 
      });
    });
  }

  marker_stream() async{//Here, we are basically doing the same as 'polyline_stream' but for markers. 
    marker_data = FirebaseFirestore.instance.collection('location').doc(FirebaseAuth.instance.currentUser.uid).snapshots().listen((snapshot){
      marker_list.clear(); //We clear the list each time the stream updates so that changes in Firebase actually translate to the changes on screen.
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

  move_camera_to_current_location() async{
    Position position = await fetch_user_location(); //updating the 'lat' and 'long' variables.
    _controller.moveCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
                  //This update's the map's camera to the given latitude and longitude.
		  //The "moveCamera" method takes in either normal methods or static
		  //methods of the "CameraUpdate" class. Static methods are methods
		  //of a class that you access through the class directly, not through an	
		  //object of the class. For example, here, "newLatLng" is a static method
		  //of the "CameraUpdate" class.
  }
  
  location_for_initial_load() async{
    Position position = await fetch_user_location();
    setState((){
      lat = position.latitude;
      long = position.longitude;
    });
  }

  fetch_user_location() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high); //This is the method of the 'geolocator' plugin 
     											             //that fetches current user location. 
    return position;
  }

  location_stream() {
    location_data = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high).listen((Position _position){
      setState((){
	polyline_points.add(LatLng(_position.latitude, _position.longitude));
      });
    });
  }

}


