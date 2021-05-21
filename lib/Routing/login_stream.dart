import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Cloud/cloud.dart';

Stream login_stream() async*{
  await for (var snapshot in FirebaseAuth.instance.authStateChanges()){ //Always yield something. If you don't yield in a listen of a stream then 
    									//even if the stream updates later, the changes won't show up for some reason.
    if(snapshot == null){
      yield false;
    }
    else if(snapshot.providerData[0].providerId == "password"){
      if(snapshot.emailVerified){
	yield true;
      }
      else{
	yield false;
      }
    }
    else{
      var token_document = await FirebaseFirestore.instance.collection('token').doc(snapshot.uid).get();
      if(token_document.exists){
	yield true;
      }
      else{
	await firsttimelogin(1);
	yield true;
      }
    }
  }
}

