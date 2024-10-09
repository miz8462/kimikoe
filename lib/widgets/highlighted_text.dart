import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText(
    this.text, {
    this.highlightColor,
    super.key,
  });
  final String text;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: highlightColor,
      child: Text(
        text,
        style: TextStyle(color: textDark),
      ),
    );
  }
}
