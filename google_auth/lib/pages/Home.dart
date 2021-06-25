import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_auth/pages/authPages/Login.dart';
import 'package:google_auth/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new CircleAvatar(
            backgroundColor: Colors.brown[600],
            backgroundImage: NetworkImage("${user!.photoURL}"),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("${user!.displayName}"),
          ),
          ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => Login(),
              //     ));
            },
            child: Text("Logout"),
          )
        ],
      ),
    ));
  }
}
