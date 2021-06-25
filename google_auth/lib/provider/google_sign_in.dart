import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  // this is code for make collection and add data to firestore

  final googleSignin = GoogleSignIn();
 

  late bool _isSigningIn; /*this is use for loading indicator not for signed in or not */

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future login() async {
     isSigningIn = true;

    final user = await googleSignin.signIn();
    if (user == null) {
      isSigningIn = false;

      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      isSigningIn = false;
    }
  }

void logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user!.providerData[0].providerId=='google.com'){
      await GoogleSignIn().disconnect();
    }
    FirebaseAuth.instance.signOut();
  }
    
 
}
