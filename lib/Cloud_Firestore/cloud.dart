import 'package:cloud_firestore/cloud_firestore.dart'; //Package required to use the cloud services of firebase. The package is called cloud firestore.
import 'package:firebase_auth/firebase_auth.dart'; //Package required to use the auth services of firebase.

Future<void> firsttimelogin(int token) async{ //Watch this video: "https://www.youtube.com/watch?v=1xPMbwOFa9I&t=198s" for general understanding.
  CollectionReference users = FirebaseFirestore.instance.collection('token');
  users.doc(FirebaseAuth.instance.currentUser.uid.toString()).set({
    'token': token, //The value of the 'token' determines the following actions when the user logs in:
                    //i.) If the value is '1', then that means the user is logging in for the first time since the creation of the account, thus they
                    //should be directed to the respective page.
                    //ii.) If the value is '0', then that means the user should be directed to their feed.
                    //iii.) If the value is '-1', then that means the user should be directed to a page where they set their unique username.
                    //iv.) If the value is '-2', then that means the user should be directed to a page where they set their profile picture.
    'username': "",
  });
}

final firestoreInstance = FirebaseFirestore.instance; //This instance is required to use Firebase's cloud services. Read this for more clarification: 
 					              //"https://firebase.flutter.dev/docs/firestore/usage/". <-- Cloud firestore documentation.

void update_token(token){ //This updates the token talked about previously based on choices of the user. Go to this link to see how the tokens get
                          //changed in the context of this app: shorturl.at/atDIP, and read the cloud firestore documentation to understand the general 
                          //syntax used to update fields in database (It's somewhere towards the bottom of the documentation.)
  firestoreInstance
      .collection("token")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .update({"token": token}).then((_){
	print("Success!");
      });
} 

void update_username(username){ //This is used to set the user's username. When they sign up initially, the field is empty. 
  firestoreInstance
      .collection("token")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .update({"username": username}).then((_){
	print("Success!");
      });
}
