import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream login_stream() async*{
  await for (var snapshot in FirebaseAuth.instance.authStateChanges()){
    yield snapshot;
  }
}

