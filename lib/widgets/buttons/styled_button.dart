import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class StyledButton extends StatelessWidget {
  const StyledButton(
    this.text, {
    this.isSending = false,
    this.onPressed,
    this.textColor = textWhite,
    this.backgroundColor = mainBlue,
    this.borderSide = BorderSide.none,
    super.key,
  });

  final bool? isSending;
  final String text;
  final void Function()? onPressed;
  final Color textColor;
  final Color backgroundColor;
  final BorderSide borderSide;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius4,
        ),
        side: borderSide,
        fixedSize: Size.fromWidth(double.maxFinite),
      ),
      child: isSending!
          ? const SizedBox(
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
    );
  }
}
