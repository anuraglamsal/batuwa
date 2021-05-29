import 'package:flutter/material.dart'; 
import 'package:email_validator/email_validator.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgotpassword.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class signinform extends StatefulWidget{ //Needs to be stateful because we show messages based on errors of sign in.
  @override
  _signinformState createState() => _signinformState();
} 

class _signinformState extends State<signinform>{
  bool successful = false;
  bool successful_2 = false;
  TextEditingController emailController = TextEditingController(); //These controllers are used to fetch form-entered data in real-time.
  TextEditingController passwordController = TextEditingController(); 
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Color labelcolor1 = Color(0xff000000);
  Color labelcolor2 = Color(0xff000000);
  var onpressed = null;
  AutovalidateMode _autovalidatemode = AutovalidateMode.disabled;
  bool password_visibility = false;

  @override
  void initState(){
    super.initState();
    emailController.addListener(change_disable_or_enable);
    passwordController.addListener(change_disable_or_enable);
  }

  change_disable_or_enable(){
    if(emailController.text != "" && passwordController.text != ""){
      setState((){
	onpressed = (){
	  if(formkey.currentState.validate()){
	    setState((){
	      successful = true;
	      _autovalidatemode = AutovalidateMode.disabled;
	    });
	    signinUser(emailController.text, passwordController.text);
	  }
	  else{
	    setState((){
	      _autovalidatemode = AutovalidateMode.onUserInteraction;
	    });
	  }
	};
      });
    }
    else{
      setState((){
	onpressed = null;
      });
    }
  }  

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Form(
	key: formkey, 
	autovalidateMode: _autovalidatemode,
	child: Container(
	  alignment: Alignment.center, 
	  color: Color(0xffffffff),
	  child: Column(
	    mainAxisAlignment: MainAxisAlignment.start, 
	    children: [
	      SizedBox(height: 33),
	      Focus(
		onFocusChange: (hasFocus){
		  setState((){
		    labelcolor1 = hasFocus ? Color(0xff07B0B5) : Color(0xff000000);
		  });
		},
		child: Container(
		  width: 300,
		  child:TextFormField(
		    controller: emailController, 
		    style: TextStyle(color: Colors.black),
		    decoration: InputDecoration(
		      filled: true,
		      fillColor: Color(0xfff2f2f2),
		      labelText: "Email",
		      labelStyle: TextStyle(
			color: labelcolor1,
		      ),
		      contentPadding: EdgeInsets.fromLTRB(13, 32, 32, 0),
		      border: OutlineInputBorder(),
		      focusedBorder: OutlineInputBorder(
			borderSide: BorderSide(color: Color(0xff07B0B5), width: 2.0,),
		      ),
		    ),
		    cursorColor: Colors.blueGrey,
		    validator: (value){  
		      if(value.isEmpty){
			return "Required"; 
		      }
		      else{
			if(!EmailValidator.validate(value)){
			  return "Not a valid email";
			}
		      }
		    },
		  ),
		),
	      ),
	      SizedBox(height: 20),
	      Focus(
		onFocusChange: (hasFocus){
		  setState((){
		    labelcolor2 = hasFocus ? Color(0xff07B0B5) : Color(0xff000000);
		  });
		},
		child: Container(
		  width: 300,
		  child: TextFormField(
		    controller: passwordController, 
		    style: TextStyle(color: Colors.black),
		    decoration: InputDecoration(
		      filled: true,
		      fillColor: Color(0xfff2f2f2),
		      suffixIcon: IconButton(
			onPressed: (){
			  if(!password_visibility){
			    setState((){
			      password_visibility = true;
			    });
			  }
			  else{
			    setState((){
			      password_visibility = false;
			    });
			  }
			},
			icon: Icon(Icons.visibility, color: password_visibility ? Color(0xff07B0B5) : Colors.grey,),
		      ),
		      errorMaxLines: 3,
		      labelText: "Password",
		      labelStyle: TextStyle(
			color: labelcolor2,
		      ),
		      contentPadding: EdgeInsets.fromLTRB(13, 32, 32, 0),
		      border: OutlineInputBorder(),
		      focusedBorder: OutlineInputBorder(
			borderSide: BorderSide(color: Color(0xff07B0B5), width: 2.0,),
		      ),
		    ),
		    cursorColor: Colors.blueGrey,
		    validator: (value){ 
		      if(value.isEmpty){
			return "Required";
		      }
		      else if(value.length<12){
			return "A password of length more than or equal to 12 is required";
		      }
		      else if(!verifyPasswordRules(value)){
			return "Password should be a combination of at least one of each of uppercase and lowercase letters, digits and special characters (! @ # \$ & * ~ ).";
		      }
		    },
		    obscureText: !password_visibility, 
		  ),
		),
	      ),
	      SizedBox(height: 20),
	      successful ?
		  CircularProgressIndicator(
		    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff07B0B5)),
		  ) :
		  Container(
		    height: 42, 
		    width: 300,
		    child: ElevatedButton(
		      onPressed: onpressed,
		      child: Text("SIGN IN",),
		      style: ButtonStyle(
			backgroundColor: MaterialStateProperty.resolveWith<Color>(
			  (Set<MaterialState> states) {
			    if (states.contains(MaterialState.pressed))
			      return Color(0xff07B0B5); //On pressed color
			    else if (states.contains(MaterialState.disabled))
			      return Color.fromRGBO(7, 176, 181, 0.2); //Disabled color
			    return Color(0xff07B0B5); //Enabled color
			  },
			), 
		      ),
		    ),
		  ),
		  SizedBox(height: 6),
		  Row(
		    children: [
		      SizedBox(width: 210),
		      GestureDetector(
			child: Text("Forgot your password?", style: TextStyle(fontSize: 12, color: Color(0xffBBB9B9),)),
			onTap: (){
			  Navigator.push(
			    context, 
			    MaterialPageRoute(builder: (context) => ForgotPassword()),
			  );
			},
		      ),
		    ],
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
		  SizedBox(height: 15),
		  successful_2 ?
		      CircularProgressIndicator(
			valueColor: AlwaysStoppedAnimation<Color>(Color(0xff07B0B5)),
		      ) :
			Row(
			  children: [
			    SizedBox(width: 125),
			    Stack(
			      children:[
				SvgPicture.asset('assets/images/google-icon.svg', width: 25, height: 25,),
				Positioned.fill(
				  child: Material(
				    color: Colors.transparent,
				    child: InkWell(
				      customBorder: CircleBorder(),
				      onTap:(){
					google_sign_in();
				      },
				    ),
				  ),
				),
			      ],
			    ),
			    SizedBox(width: 17),
			    Stack(
			      children:[
				SvgPicture.asset('assets/images/facebook-icon.svg', width: 28, height: 28,),
				Positioned.fill(
				  child: Material(
				    color: Colors.transparent,
				    child: InkWell(
				      splashColor: Color.fromRGBO(238, 238, 238, 0.35),
				      customBorder: CircleBorder(),
				      onTap:(){
					facebook_sign_in();
				      },
				    ),
				  ),
				),
			      ],
			    ),
			    SizedBox(width: 17),
			    Stack(
			      children:[
				SvgPicture.asset('assets/images/twitter-icon.svg', width: 25, height: 25,),
				Positioned.fill(
				  child: Material(
				    color: Colors.transparent,
				    child: InkWell(
				      customBorder: CircleBorder(),
				      onTap:(){
					twitter_sign_in();
				      },
				    ),
				  ),
				),
			      ],
			    ),
			  ],
			),
		]
	      )
	    )
	  ),
	);
      }

  //All of the functions being used in the widget.

  google_sign_in() async{
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn(); //Opens the dialog box to choose which account to sign in with.
    if(googleUser != null){
      setState((){
	successful_2 = true;
      });
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication; //The credentials of the account you chose. 
    final credential = GoogleAuthProvider.credential( //Creates a new credential to sign in here. Idk why.
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential); //Sign in. If the user escapes the dialog box without 
      									 //choosing any account, null is returned.

  }

  Future<UserCredential> facebook_sign_in() async {
    final LoginResult result = await FacebookAuth.instance.login(); //Opens the dialog box.
    if(result.status == LoginStatus.success){
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token); //Creates a new credential
      return await FirebaseAuth.instance.signInWithCredential(credential); //Sign in
    }
    return null; //If the user escaped the dialog box, return null.
  }

  Future<UserCredential> twitter_sign_in() async {
    // Create a TwitterLogin instance
    final TwitterLogin twitterLogin = new TwitterLogin(
      consumerKey: 'V4fcIrGdXq3gSt4Sc5Ak9yFkp',
      consumerSecret: 'QRQUNbAyMmPnI6rvClQqohXDRklP5FRIbR98naM7qYS2zXZsfy',
    );
    // Trigger the sign-in flow
    final TwitterLoginResult loginResult = await twitterLogin.authorize();
    // Get the Logged In session
    final TwitterSession twitterSession = loginResult.session;
    // Create a credential from the access token
    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: twitterSession.token,
      secret: twitterSession.secret,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);
  }

  bool verifyPasswordRules(String value){ //This allows us to have the password condition as described above.
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  signinUser(email, password) async{
    bool flag = true;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword( //Read the 'Flutter Firebase Auth' docs to understand this.
	email: email,
	password: password
      );
    } on FirebaseAuthException catch (e) {
      bool flag = false;
      if (e.code == 'user-not-found') { //If errors are found, show them on screen.
	setState((){ 
	   successful = false;
        });
	dialogbox("User with this e-mail doesn't exist.");
      } else if (e.code == 'wrong-password') {
	setState((){
	  successful = false;
	});
	dialogbox("The entered password is wrong.");
      }
    }
    if(flag){ //If no errors found, you still need to check if the email has been verified or not. 
      if(!auth.currentUser.emailVerified){ //Check if email is verified.
	auth.currentUser.sendEmailVerification(); //If not, send the verification email again.
	await auth.signOut();
	setState((){
	  successful = false;
        });
	dialogbox("This e-mail hasn't yet been verified. Please check your inbox.");
      }
    }
  }

  dialogbox(String message){
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
	content: Text(message,),
	actions: [
	  MaterialButton(
	    child: Text("OK", style: TextStyle(color: Color(0xff07B0B5),),),
	    onPressed: (){
	      Navigator.pop(context);
	    },
	  ),
	],
      ),
    );
  }

} 
