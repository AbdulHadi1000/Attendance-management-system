import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Boldtext extends StatelessWidget {
  final double size;
  final Color? color;
  final String text;
  final String font;
  TextOverflow textOverflow;

  Boldtext({
    super.key,
    this.color = Colors.black,
    this.size = 20,
    this.font = "font30",
    this.textOverflow = TextOverflow.ellipsis,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontFamily: font,
          fontSize: size,
          fontWeight: FontWeight.bold),
    );
  }
}
