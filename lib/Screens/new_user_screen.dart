import 'package:flutter/material.dart';
import '../Cloud/cloud.dart';
import 'package:flutter_svg/flutter_svg.dart';


//This is the page that the user is directed to when they login for the first time i.e. when their token is '1'.
class firsttimeLogin extends StatefulWidget{
  @override
  _firsttimeLoginState createState() => _firsttimeLoginState();
}

class _firsttimeLoginState extends State<firsttimeLogin>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
	alignment: Alignment.center,
	child: Column(
	  children: <Widget>[
	    SizedBox(height: 100),
	    SvgPicture.asset('assets/images/welcome_banner.svg', height: 100),
	    SizedBox(height: 45),
	    Container(
	      height: 42, 
	      width: 200,
	      child: ElevatedButton(
		onPressed: (){},
		child: Text("SIGN IN",),
		style: ButtonStyle(
		  backgroundColor: MaterialStateProperty.resolveWith<Color>(
		    (Set<MaterialState> states) {
		      if (states.contains(MaterialState.pressed))
			return Color(0xff07B0B5); //On pressed color
		      else if (!states.contains(MaterialState.disabled))
			return Color(0xff07B0B5); //Disabled color
		      //return Color(0xff07B0B5); //Enabled color
		    },
		  ), 
		),
	      ),
	    ),
	    /*GestureDetector(
	      child: Container(
		height: 40,
		width: 170,
		alignment: Alignment.center,
		decoration: BoxDecoration(
		  color: Colors.blue[600],
		  borderRadius: BorderRadius.all(Radius.circular(15)),
		),
		child: Text(
		  "Start posting right away", style: TextStyle(color: Colors.white, fontFamily: 'Mohave', fontSize: 16,),
		),
	      ),
	      onTap: (){
		update_token(0); //When they press this container, the token is updated to '0'. Token logic: shorturl.at/atDIP
	      },
	    ),*/
	    SizedBox(height: 17),
	    Text(
	      "or", style: TextStyle(fontSize: 17, color: Colors.white),
	    ),
	    SizedBox(height: 17),
	    GestureDetector(
	      child: Container(
		height: 50,
		width: 250,
		alignment: Alignment.center,
		decoration: BoxDecoration(
		  color: Colors.blue[600],
		  borderRadius: BorderRadius.all(Radius.circular(15)),
		),
		child: Text(
		  "Customize your profile", style: TextStyle(color: Colors.white, fontFamily: 'Mohave', fontSize: 22,),
		),
	      ),
	      onTap: (){
		update_token(-1); //When they press this container, the token is updated to '-1'. Token logic: shorturl.at/atDIP
	      },
	    ),
	  ],
	),

      ),
    );
  }
}

