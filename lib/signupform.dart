import 'package:flutter/material.dart';//for flutter syntax 
import 'package:email_validator/email_validator.dart';//for email validator
import 'package:firebase_auth/firebase_auth.dart';//for firebase auth
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';//to hide or show widgets according to keyboard being on screen or not.

class signupform extends StatefulWidget{//We turn our form into a stateful widget because this allows us to rebuild the form to showcase the changes
  //that we want to after:
  //When the form is submitted and successful validation occurs, a message is shown to indicate that. For that,
  //you need to rebuild the widget, and that service is present for stateful widgets only.
  @override
  _signupformState createState() => _signupformState();
}

class _signupformState extends State<signupform>{


  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  //Whenever the user writes things in the textfield of the form, the form's state has obviously changed. After the user has completed the form,
  //they will press the submit button. On pressing the submit button, we want the state of the form as it is then to be able to use the entered
  //data for validation. The global key somehow creates a way to do that.
  bool validated = false;//We declare this variable as am indication that the submitted form is valitaed, which enables us to showcase a text widget.
  //More context about this is apparent as you read the code below.
  bool email_exists = false;
  bool image = true;
  TextEditingController emailController = new TextEditingController(); //This allows us to retrieve the text entered in email field.
  TextEditingController passwordController = new TextEditingController(); //This allows us to retrieve the text entered in password field.
  @override
  Widget build(BuildContext context){
    return KeyboardVisibilityBuilder(//This allows us to do stuff inside this widget depending upon if keyboard is on the screen or not. You don't
       			             //even need setState. It's cool.
      builder: (context, isKeyboardVisible){
	return Form(
	  key: formkey, //You provide the name of the global key here in this manner.
	  child: Container(
	    alignment: Alignment.center, //Brings the main axis(vertical axis) of the container to the center
	    color: Colors.black87,
	    child: Column(
	      mainAxisAlignment: MainAxisAlignment.start, //aligns the column along the starting point of the main axis i.e. from the top of it.
	      children: <Widget>[
		SizedBox(height: 10),
		!isKeyboardVisible ? //Only shows when keyboard is not on screen. If keyboard is on screen, it goes away, leaving space for resize of 
		                     //the form.
		  Image.asset('assets/images/logo.png', width: 300, height: 150):SizedBox(),
		Container(
		  height: 58,
		  width: 350,
		  alignment: Alignment.center,
		  decoration: BoxDecoration(
		    color: Colors.blueGrey[700],
		    borderRadius: BorderRadius.all(Radius.circular(15)),
		  ),
		  child: Text(
		    "Create your account here",
		    style: TextStyle(fontSize: 26, color: Colors.white),
		  ),
		),
		SizedBox(height: 17),
		Container(
		  alignment: Alignment.center,
		  height: 50,
		  width: 330,
		  decoration: BoxDecoration(
		    color: Colors.blueGrey[800],
		    borderRadius: BorderRadius.all(Radius.circular(20)),
		  ),
		  child: Text(
		    "E-mail",
		    style: TextStyle(fontSize: 22, color: Colors.white,),
		  )
		),                                                            
		SizedBox(height:10),
		Container(
		  width: 330,
		  child:TextFormField(
		    controller: emailController, //Inside 'controller', put the name of the variable given above created using 'TextEditingController'.
		    //Now, we can retrieve the text in any part of this class using 'emailController.text'.
		    style: TextStyle(color: Colors.white),
		    decoration: InputDecoration(
		      enabledBorder: OutlineInputBorder(
			borderSide: BorderSide(
			  color:Colors.blueGrey[700],
			),
		      ),
		      border: OutlineInputBorder(),
		      focusedBorder: OutlineInputBorder(
			borderSide: const BorderSide(color: Colors.blueGrey, width: 2.0),	
		      ),
		    ),
		    cursorColor: Colors.blueGrey,
		    validator: (value){ //Once the submit button is pressed, the 'value' here becomes the data that the user has 
		      //entered in this particular text field. 
		      if(value.isEmpty){ //Checking if the text field is null or not.
			setState((){ //We want to remove the successful validation message if the user fills in the form again but gets it wrong.
			  //We also want to remove the "email already exists" message because that might not be the problem. If it is,
			  //then it is handled in another place. The use of this 'setState' method is talked about inside the
			  //'registerNewUser' field.
			  validated = false;
			  email_exists = false;
			});
			return "Required"; //If null, you tell the user that they need to enter something.
		      }
		      else{
			if(!EmailValidator.validate(value)){//This function validates our email. I used a package for this which is imported above.
			  setState((){ //This is to prevent the "Successful validation!" text widget from appearing if it was still there because of
			    //previous use of the form. We don't want that now because our email validation didn't work.
			    validated = false;
			    email_exists = false;
			  });
			  return "Not a valid email";
			}
		      }
		    },
		  ),
		),
		SizedBox(height: 10),
		Container(
		  alignment: Alignment.center,
		  height: 50,
		  width: 330,
		  decoration: BoxDecoration(
		    color: Colors.blueGrey[800],
		    borderRadius: BorderRadius.all(Radius.circular(20)),
		  ),
		  child: Text(
		    "Password",
		    style: TextStyle(fontSize: 22, color: Colors.white,),
		  )
		),
		SizedBox(height: 10),
		Container(
		  width: 330,
		  child: TextFormField(
		    controller: passwordController, //Same as email.
		    style: TextStyle(color: Colors.white),
		    decoration: InputDecoration(
		      errorMaxLines: 3,
		      enabledBorder: OutlineInputBorder(
			borderSide: BorderSide(
			  color:Colors.blueGrey[700],
			),
		      ),
		      border: OutlineInputBorder(),
		      focusedBorder: OutlineInputBorder(
			borderSide: const BorderSide(color: Colors.blueGrey, width: 2.0),	
		      ),
		    ),
		    cursorColor: Colors.blueGrey,
		    validator: (value){ //Same as the above validator.
		      if(value.isEmpty){
			setState((){
			  validated = false;
			  email_exists = false;
			});
			return "Required";
		      }
		      else if(value.length<12){
			setState((){
			  validated = false;
			  email_exists = false;
			});
			return "A password of length more than or equal to 12 is required";
		      }
		      else if(!validateStructure(value)){
			setState((){
			  validated = false;
			  email_exists = false;
			});
			return "Password should be a combination of at least one of each of uppercase and lowercase letters, digits and special characters (! @ # \$ & * ~ ).";
		      }
		    },
		    obscureText: true //this makes the password obscure while entering in the field.
		  ),
		),
		SizedBox(height: 15),
		Container(
		  height: 42, 
		  child: RaisedButton(
		    color: Colors.blueGrey[700],
		    onPressed: () {
		      if(formkey.currentState.validate()){ //Once the user presses the submit button, the method called 
			//inside this if statement gets the current state of the form, runs the respective validators
			//of the text fields and goes inside this if block if validation doesn't yield any errors.
			//Notice that the first part of the method called should be the name of the global key.

			//Do the stuff to do if form is validated inside this block.
			registerNewUser(emailController.text, passwordController.text);//This function is used to send the data of the user to
			//firebase's database. You send the email and password
			//entered in the field as arguments.
		      }
		    },
		    child: Text(
		      "Sign Up",
		      style: TextStyle(fontSize: 18, color: Colors.white),
		    ),
		    shape: RoundedRectangleBorder(
		      borderRadius: BorderRadius.circular(10.0),
		    ),
		  ),
		),
		SizedBox(height:20),
		validated ? Text("Successful validation! Please verify your email address so that you can sign in.",
		  style: TextStyle(fontSize:17, color: Colors.white), textAlign: TextAlign.center,):SizedBox(),//When the boolean variable "validated" is true, this text widget is shown. You need 
		//the ":SizedBox()" too for some reason. 
		email_exists ? Text("User with that e-mail already exists",//Same as above but for "email already eixsts".
		  style: TextStyle(fontSize:17, color: Colors.white), textAlign: TextAlign.center,):SizedBox(),
		]
	      )
	    )
	  );
      }
    );
  }

    bool validateStructure(String value){ //You send password inside this and this sends "true" bool if password has the necessary condition satisfied.
      //The condition is written inside the return value inside "validation" in the password text field widget.
      String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value);
    }

    FirebaseAuth auth = FirebaseAuth.instance; //This is required to do before using the firebase auth services.

    void registerNewUser(email, password) async{//You need to make this function 'async' for some reason.
      bool flag = true;//The logic for this is below. Keep on reading.
      try {
	UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword( //This is how you register the user.
	  email: email, //in 'email:', you send the email sent by the user inside onpressed.
	  password: password  //you do the same for password.
	);
      } on FirebaseAuthException catch (e) {
	if (e.code == 'email-already-in-use') {
	  flag = false;
	  setState((){//when you want state of your widget to change, you send the changes inside this 'setState' method. This rebuilds the widget taking
	    //these changes in account. Here, as the email is already in the database, we want to show the message corresponding to it, and
	    //remove the message corresponding to successful validation if present. Thus, the respective booleans have the respective values.
	    validated = false;
	    email_exists = true;
	  });
	}
      }catch(e){
	print(e);
      }
      if(flag == true){//Whenever there is no exception for email, this means that the user data has been fully validated. Thus, we show the 
	//"Successful validation" message to the user and remove the "email already exists" message if there is any. Thus, the
	//respective booleans have the respective values.
	//User user = auth.currentUser;
	auth.currentUser.sendEmailVerification();
	setState((){
	  email_exists = false;
	  validated = true;
	});
      }
    }
  }
