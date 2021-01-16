import 'package:firebase_auth/firebase_auth.dart';//for firebase auth
import 'dart:async';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> logout() async{
  await auth.signOut();
}

bool null_test(){
  User user = auth.currentUser;
  if(user == null){
    return false;
  }
  else{
    return true;
  }
}



