import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Lighttext extends StatelessWidget {
  double size;
  final String text;
  final String font;
  Color color;
  TextOverflow textOverflow;

  Lighttext({
    super.key,
    this.size = 20,
    this.font = "font30",
    this.color = Colors.black,
    this.textOverflow = TextOverflow.ellipsis,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: textOverflow,
      text,
      style: TextStyle(
        color: color,
        fontFamily: font,
        fontSize: size,
      ),
    );
  }
}
