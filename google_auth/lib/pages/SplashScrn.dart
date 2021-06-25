import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_auth/pages/Home.dart';
import 'package:google_auth/pages/authPages/Login.dart';

import 'package:google_auth/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

// import 'package:google_auth/'
class SplashScrn extends StatefulWidget {
  const SplashScrn({Key? key}) : super(key: key);

  @override
  _SplashScrnState createState() => _SplashScrnState();
}

class _SplashScrnState extends State<SplashScrn> {
  @override
  Widget build(BuildContext context) {
   
 Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          Center(child: CircularProgressIndicator()),
        ],
      );

    return  Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);

              if (provider.isSigningIn) {
                return buildLoading();
              } else if (snapshot.hasData) {
                return Home();
              } else {
                return Login();
              }
            },
          ),
        ),
      );
  }
}
