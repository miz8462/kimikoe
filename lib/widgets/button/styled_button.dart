import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';

class StyledButton extends StatelessWidget {
  const StyledButton(
    this.text, {
    this.isSending = false,
    this.textColor = textWhite,
    this.backgroundColor = mainColor,
    this.borderSide = BorderSide.none,
    this.onPressed,
    super.key,
  });

  final String text;
  final bool? isSending;
  final Color textColor;
  final Color backgroundColor;
  final BorderSide borderSide;
  final void Function()? onPressed;

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
        fixedSize: const Size.fromWidth(double.maxFinite),
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
