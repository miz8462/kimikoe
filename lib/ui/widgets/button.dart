import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

const maxWidth = double.maxFinite;

class Button extends StatelessWidget {
  const Button(
    this.text, {
    this.textColor = textWhite,
    this.backgroundColor = mainBlue,
    this.buttonSize = buttonS,
    this.borderSide = BorderSide.none,
    super.key,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double buttonSize;
  final BorderSide borderSide;  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonSize,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: borderSide,
          fixedSize: const Size.fromWidth(maxWidth),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
