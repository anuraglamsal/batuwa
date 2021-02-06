import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> firsttimelogin(int token) async{
  CollectionReference users = FirebaseFirestore.instance.collection('token');
  users.doc(FirebaseAuth.instance.currentUser.uid.toString()).set({
    'token': token,
  });
}

final firestoreInstance = FirebaseFirestore.instance;

void update_token(){
  firestoreInstance
      .collection("token")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .update({"token": 0}).then((_){
	print("Success!");
      });
} 
