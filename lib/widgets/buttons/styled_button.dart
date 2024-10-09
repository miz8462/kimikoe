import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class StyledButton extends StatelessWidget {
  const StyledButton(
    this.text, {
    this.isSending = false,
    this.onPressed,
    this.textColor = textWhite,
    this.backgroundColor = mainBlue,
    this.buttonSize = buttonS,
    this.borderSide = BorderSide.none,
    this.width = double.maxFinite,
    super.key,
  });

  final bool? isSending;
  final String text;
  final void Function()? onPressed;
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
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius4,
          ),
          side: borderSide,
          fixedSize: Size.fromWidth(width),
        ),
        child: isSending!
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                ),
              ),
      ),
    );
  }
}
