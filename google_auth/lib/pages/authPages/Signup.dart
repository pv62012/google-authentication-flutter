import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_auth/pages/Home.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    CollectionReference users = FirebaseFirestore.instance.collection("users");

  void registerToFb() {
      firebaseAuth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((result) {
        users.add({
          "email": emailController.text,
          "name": nameController.text,
          "phone": numberController.text
        }).then((result) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        })..catchError((err) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(err.message),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      });
      }).catchError((err) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(err.message),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register Yourself"),
      ),
      body: Container(
          child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            labelText: "Enter User Name",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: (e) {
                          if (e!.isEmpty) {
                            return 'Enter User name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: "Enter Email",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "this Field is required"),
                          EmailValidator(errorText: "Invalid Email Address "),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: "Enter Password",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Password Is Required"),
                          MinLengthValidator(6,
                              errorText: "Minimum 6 Characters Required"),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: numberController,
                        decoration: InputDecoration(
                            labelText: "Enter Mobile Number",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        validator: (e) {
                          if (e!.isEmpty) {
                            return 'Enter Mobile number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            registerToFb();
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}
