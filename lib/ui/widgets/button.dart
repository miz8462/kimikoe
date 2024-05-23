import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class Button extends StatelessWidget {
  const Button(
    this.text, {
    this.textColor = textWhite,
    this.backgroundColor = mainBlue,
    this.buttonSize = buttonS,
    this.borderSide = BorderSide.none,
    this.width = double.maxFinite,
    super.key,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double buttonSize;
  final BorderSide borderSide;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonSize,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius8,
          ),
          side: borderSide,
          fixedSize: Size.fromWidth(width),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
