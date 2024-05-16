import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class Button extends StatelessWidget {
  const Button(
    this.name, {
    this.textColor = textWhite,
    this.backgroundColor = mainBlue,
    this.buttonSize = 40,
    this.borderSide = BorderSide.none,
    super.key,
  });

  final String name;
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
          fixedSize: const Size.fromWidth(double.maxFinite),
        ),
        child: Text(
          name,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
