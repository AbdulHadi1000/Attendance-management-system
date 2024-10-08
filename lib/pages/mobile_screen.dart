import 'package:attdendance_management_system/pages/leavepage.dart';
import 'package:attdendance_management_system/pages/loginpage.dart';
import 'package:attdendance_management_system/pages/signuppage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MobileScreen extends StatelessWidget {
  MobileScreen({super.key});

  List<Widget> pages = [Loginpage(), SignUpPage()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Loginpage(),
      ),
    );
  }
}
