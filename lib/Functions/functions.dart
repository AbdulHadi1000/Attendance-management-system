import 'package:flutter/material.dart';

class Assets extends StatelessWidget {
  const Assets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.asset('assets/dpp.jpg'),
      ),
    );
  }
}
