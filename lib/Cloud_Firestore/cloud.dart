import 'package:cloud_firestore/cloud_firestore.dart'; //Package required to use the cloud services of firebase. The package is called cloud firestore.
import 'package:firebase_auth/firebase_auth.dart'; //Package required to use the auth services of firebase.
import 'package:uuid/uuid.dart';

final firestoreInstance = FirebaseFirestore.instance; //This instance is required to use Firebase's cloud services. Read this for more clarification: 
 					              //"https://firebase.flutter.dev/docs/firestore/usage/". <-- Cloud firestore documentation.
CollectionReference users = firestoreInstance.collection('token');
CollectionReference location = firestoreInstance.collection('location');
final firebaseAuth = FirebaseAuth.instance;
var uuid = Uuid();

firsttimelogin(int token){ //Watch this video: "https://www.youtube.com/watch?v=1xPMbwOFa9I&t=198s" for general understanding.
  users.doc(firebaseAuth.currentUser.uid.toString()).set({
    'token': token, //The value of the 'token' determines the following actions when the user logs in:
                    //i.) If the value is '1', then that means the user is logging in for the first time since the creation of the account, thus they
                    //should be directed to the respective page.
                    //ii.) If the value is '0', then that means the user should be directed to their feed.
                    //iii.) If the value is '-1', then that means the user should be directed to a page where they set their unique username.
                    //iv.) If the value is '-2', then that means the user should be directed to a page where they set their profile picture.
    'username': "",
  });
}

save_location(name, lat, long){
  String id = uuid.v4();
  location.doc(firebaseAuth.currentUser.uid.toString()).set({
    '$id': [name, lat, long],
  }, SetOptions(merge: true)); //This option allows us to save multiple fields in the document without replacement of fields occuring. 
}

update_token(token){ //This updates the token talked about previously based on choices of the user. Go to this link to see how the tokens get
                     //changed in the context of this app: shorturl.at/atDIP, and read the cloud firestore documentation to understand the general 
                     //syntax used to update fields in database (It's somewhere towards the bottom of the documentation.)
  users.doc(firebaseAuth.currentUser.uid).update({"token": token}).then((_){
    print("Success");
  });
} 

update_username(username){ //This is used to set the user's username. When they sign up initially, the field is empty. 
   users.doc(firebaseAuth.currentUser.uid).update({"username": username}).then((_){
     print("Success");
   });
}

delete_field(id){
  location.doc(firebaseAuth.currentUser.uid).update({"$id": FieldValue.delete()}).then((_){
    print("Success");
  });
}
