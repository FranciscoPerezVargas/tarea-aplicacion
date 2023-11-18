import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginGoogleUtils{

  //Cuidado con TAG esto hace referencia a la clase, es mejor usar la clase en si.
  static const String TAG = "LoginGoogleUtils";
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<User?> signInWithGoogle() async{
    log(TAG+ ", signInWithGoogle() init...");

  }

}