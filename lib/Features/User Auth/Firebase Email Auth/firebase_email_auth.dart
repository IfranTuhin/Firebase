



import 'package:firebase_auth/firebase_auth.dart';

class FirebaseEmailAuth{

  FirebaseAuth _auth = FirebaseAuth.instance;

  // sing up with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      print("Some error occurred");
    }
    return null;
  }

  // sing in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      print("Some error occurred");
    }
    return null;
  }

}