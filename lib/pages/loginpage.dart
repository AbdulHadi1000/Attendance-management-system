import 'package:attdendance_management_system/colors/colors.dart';
import 'package:attdendance_management_system/pages/dashboard.dart';
import 'package:attdendance_management_system/pages/signuppage.dart';
import 'package:attdendance_management_system/widgets/light_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();
  void signin(String email, String password) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      User? currentUser = FirebaseAuth.instance.currentUser;
      print("Current User Email: ${currentUser?.email}");
      print("aaaaaaaaaaaaaaaaaaaaa Email: ${email}");
    } on FirebaseAuthException catch (error) {
      print("Error :$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        backgroundColor: appBarColor,
        title: Lighttext(
          text: "Attendance Management System",
          color: Colors.white,
          size: 25,
        ),
      ),
      backgroundColor: backGroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.90,
            width: MediaQuery.sizeOf(context).width * 0.90,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
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
                            controller: _email,
                            decoration: InputDecoration(
                                label: Lighttext(
                              text: "Email",
                              color: textLabelColor,
                            )),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.05,
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
                            controller: _password,
                            decoration: InputDecoration(
                                label: Lighttext(
                              text: "Password",
                              color: textLabelColor,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.1,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appBarColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        signin(_email.text, _password.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DashBoard()));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Lighttext(
                        text: "Log In",
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.05,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(
                        color: Colors.black, // Regular text color
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color:
                                  appBarColor, // Color for the "Sign Up" link
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()));
                              })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
