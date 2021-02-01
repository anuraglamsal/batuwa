import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> firsttimelogin(int token) async{
  CollectionReference users = FirebaseFirestore.instance.collection('token');
  users.doc(FirebaseAuth.instance.currentUser.uid.toString()).set({
    'token': token,
  });
}

var result;
var firebaseUser = FirebaseAuth.instance.currentUser;
final firestoreInstance = FirebaseFirestore.instance;

Future<void> check() async{
  result = await firestoreInstance.collection("token").doc(firebaseUser.uid.toString()).get();
  print(result.data()["token"]);
}

void update_token(){
  firestoreInstance
      .collection("token")
      .doc(firebaseUser.uid)
      .update({"token": 0}).then((_){
	print("Success!");
      });
} 
