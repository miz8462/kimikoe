import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class StyledText extends StatelessWidget {
  const StyledText(
    this.text, {
    this.fontSize = fontSS,
    this.textColor = textDark,
    super.key,
  });

  final String text;
  final double fontSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, color: textColor),
    );
  }
}
