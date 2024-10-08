// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupController extends StatelessWidget {
  const SignupController({super.key});
  void signup(String email, String password) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      print("error $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
