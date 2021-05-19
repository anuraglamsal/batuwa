import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream login_stream() async*{
  var snapshot;
  var list_of_uids;
  await for (var users in FirebaseFirestore.instance.collection('token').snapshots()){
    print(users.docs[0].id);
  }
  await for (snapshot in FirebaseAuth.instance.authStateChanges()){

  }
}

