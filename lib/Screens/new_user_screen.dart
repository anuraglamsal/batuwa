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
	      height: 39, 
	      width: 188,
	      child: ElevatedButton(
		onPressed: (){
		  update_token(0); //When they press this container, the token is updated to '0'. Token logic: shorturl.at/atDIP
		},
		child: Text("START EXPLORING THE APP", style: TextStyle(fontSize: 12,),),
		style: ButtonStyle(
		  backgroundColor: MaterialStateProperty.resolveWith<Color>(
		    (Set<MaterialState> states) {
		      if (states.contains(MaterialState.pressed))
			return Color(0xff07B0B5); //On pressed color
		      else if (!states.contains(MaterialState.disabled))
			return Color(0xff07B0B5); //Disabled color
		      },
		    ), 
		  ),
		),
	      ),
	      SizedBox(height: 21),
	      Row(
		children: [
		  Expanded(
		    child: Container(
		      margin: EdgeInsets.only(left: 110, right: 5),
		      child: Divider(
			color: Color(0xff50C7CB),
			thickness: 2,
		      ),
		    ),
		  ),
		  Container(
		    width: 32,
		    height: 32,
		    child: Center(child: Text("OR", style: TextStyle(color: Color(0xff6E6C6C),),),),
		    decoration: BoxDecoration(
		      shape: BoxShape.circle,
		      border: Border.all(color: Color(0xff50C7CB), width: 2,),
		    ),
		  ),
		  Expanded(
		    child: Container(
		      margin: EdgeInsets.only(left: 5, right: 110),
		      child: Divider(
			color: Color(0xff50C7CB),
			thickness: 2,
		      ),
		    ),
		  ),
		],
	      ),
	      SizedBox(height: 21),
	      Container(
		height: 39, 
		width: 188,
		child: ElevatedButton(
		  onPressed: (){
		    update_token(-1); //When they press this container, the token is updated to '-1'. Token logic: shorturl.at/atDIP
		  },
		  child: Text("CUSTOMIZE YOUR PROFILE", style: TextStyle(fontSize: 12,),),
		  style: ButtonStyle(
		    backgroundColor: MaterialStateProperty.resolveWith<Color>(
		      (Set<MaterialState> states) {
			if (states.contains(MaterialState.pressed))
			  return Color(0xff07B0B5); //On pressed color
			else if (!states.contains(MaterialState.disabled))
			  return Color(0xff07B0B5); //Disabled color
			},
		      ), 
		    ),
		  ),
		),
	      ],
	    ),
	  ),
	);
      }
    }

