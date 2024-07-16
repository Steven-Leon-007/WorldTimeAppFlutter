import 'package:flutter/material.dart';

class SharedTextMain extends StatelessWidget {
  const SharedTextMain(this.text, this.fontSize, this.color, this.fontWeight,
      {super.key});

  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize,
          letterSpacing: 2,
          color: color,
          fontWeight: fontWeight),
    );
  }
}
