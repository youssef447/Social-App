import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//To initalize firebase
import 'package:firebase_core/firebase_core.dart';

import '../constants.dart';

mixin firebase {
  //initalize firebase
  static Future<FirebaseApp> initalize() async {
    return await Firebase.initializeApp();
  }

  //create user
  static Future<UserCredential> registerUser(String email, String pass) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass);
  }

  //sign in user
  static Future<UserCredential> signInEmailPass(String email, String pass) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
  }

  //sign in with phone num
  Future<ConfirmationResult> signInPhone(String phone) {
    return FirebaseAuth.instance.signInWithPhoneNumber(phone);
  }

  static Future<void> verifyEmail() {
    //print(FirebaseAuth.instance.currentUser!.email);
    return FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  /*    //sign in with Google acc

   Future<ConfirmationResult> signInGoogle() {
    return FirebaseAuth.instance
        .
  } */

  //delete Account

  //other functions

}
