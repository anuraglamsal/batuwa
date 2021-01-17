import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

FirebaseAuth auth = FirebaseAuth.instance; //"FirebaseAuth.instance" is required to use FirebaseAuth functionality. The variable
                                           //created here is just for convinience.

Future<void> logout() async{ //Signs the user out.
  await auth.signOut();
}

bool null_test(){ //Checks if a user is persisting or not.
  User user = auth.currentUser;
  if(user == null){
    return false;
  }
  else{
    return true;
  }
}



