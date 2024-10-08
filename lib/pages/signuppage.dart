// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:convert';

import 'package:attdendance_management_system/colors/colors.dart';
import 'package:attdendance_management_system/widgets/bold_text.dart';
import 'package:attdendance_management_system/widgets/light_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future signup(String email, String password, String username) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      print("error $error");
    }
  }

  Future storeData(String email, String username) async {
    final ByteData bytes = await rootBundle.load('assets/dpp.jpg');
    final List<int> imageData = bytes.buffer.asUint8List();
    await FirebaseFirestore.instance.collection("Userlist").doc(email).set({
      'email': email,
      'username': username,
      'photo': base64Encode(imageData),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        toolbarHeight: 70,
        backgroundColor: appBarColor,
        title: Lighttext(
          text: "Attendance Management System",
          color: Colors.white,
          size: 20,
        ),
      ),
      backgroundColor: backGroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.80,
            width: MediaQuery.sizeOf(context).width * 0.90,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Username";
                              } else {
                                return null;
                              }
                            },
                            controller: name,
                            decoration: InputDecoration(
                                label: Lighttext(
                              text: "User Name",
                              color: textLabelColor,
                            )),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.01,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Email";
                              } else if (!value.contains("@gmail.com")) {
                                return "Please Enter Correct Email";
                              } else {
                                return null;
                              }
                            },
                            controller: email,
                            decoration: InputDecoration(
                                label: Lighttext(
                              text: "Email",
                              color: textLabelColor,
                            )),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.01,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Password";
                              } else if (value.length < 8) {
                                return "Please Enter Strong Password";
                              } else {
                                return null;
                              }
                            },
                            controller: password,
                            decoration: InputDecoration(
                                label: Lighttext(
                              text: "Password",
                              color: textLabelColor,
                            )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_key.currentState!.validate()) {
                          await signup(email.text, password.text,
                              name.text); // Make sure signup is async
                          await storeData(email.text, name.text);
                          Navigator.pop(context);

                          //save data on firstore
                        }
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.30,
                        height: MediaQuery.sizeOf(context).height * 0.10,
                        alignment: Alignment
                            .center, // centers the text inside the container
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              BorderRadius.circular(8), // rounded corners
                        ),
                        child: Boldtext(
                          text: 'Sign up',
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                          color: Colors.black, // Regular text color
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                            text: 'Log in',
                            style: TextStyle(
                              color:
                                  appBarColor, // Color for the "Sign Up" link
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
