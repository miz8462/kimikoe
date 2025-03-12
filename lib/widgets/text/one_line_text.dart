import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class OneLineText extends StatelessWidget {
  const OneLineText(
    this.text, {
    this.fontSize,
    this.textColor = textDark,
    super.key,
  });

  final String text;
  final double? fontSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    );
  }
}
