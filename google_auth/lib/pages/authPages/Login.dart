import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_auth/pages/Home.dart';
import 'package:google_auth/pages/authPages/Signup.dart';
import 'package:google_auth/provider/google_sign_in.dart';
import 'package:provider/provider.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email;
  late String password;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void loginMail() {
    if (formkey.currentState != null && formkey.currentState!.validate()) {
      formkey.currentState!.save();
      signin(email, password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        }
      });
    }
  }

  showErrDialog(BuildContext context, String err) {
    // to hide the keyboard, if it is still p
    FocusScope.of(context).requestFocus(new FocusNode());
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(err),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"),
              ),
            ],
          );
        });
  }

  signin(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // return Future.value(true);

    } on FirebaseAuthException catch (e) {
      // simply passing error code as a message
      print(e);
      switch (e.code) {
        case 'invalid-email':
          showErrDialog(context, e.code);
          break;
        case 'wrong-password':
          showErrDialog(context, e.code);
          break;
        case 'user-not-found':
          showErrDialog(context, e.code);
          break;
        case 'user-disabled':
          showErrDialog(context, e.code);
          break;
        case 'too-many-requested':
          showErrDialog(context, e.code);
          break;
        case 'operation=not-allowed':
          showErrDialog(context, e.code);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Widget buildSignUp() => Column(
          children: [
            Spacer(),

            Center(
              child: Container(
                width: screenWidth * 0.80,
                child: Column(
                  children: [
                    Form(
                        key: formkey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Email",
                                ),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "this Field is required"),
                                  EmailValidator(
                                      errorText: "Invalid Email Address "),
                                ]),
                                onChanged: (val) {
                                  email = val;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Password"),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Password Is Required"),
                                  MinLengthValidator(6,
                                      errorText:
                                          "Minimum 6 Characters Required"),
                                ]),
                                onChanged: (val) {
                                  password = val;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: ElevatedButton(
                                onPressed: loginMail,
                                child: Text("Login"),
                              ),
                            )
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: OutlinedButton.icon(
                        icon:Icon(Icons.face),
                        label: Text(
                          'Sign In With Google',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black),
                        ),
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          provider.login();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //log in button

            SizedBox(height: 12),
            Text(
              'Login to continue',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: ElevatedButton(
                                onPressed:(){
                                   Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                                } ,
                                child: Text("Login using phone number"),
                              ),
                            ),
            Spacer(),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: (){},
                    child: Text(
                      "Don't have an Account? Signup here",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ))
          ],
        );

    return Stack(
      fit: StackFit.expand,
      children: [
        buildSignUp(),
      ],
    );
  }
}
