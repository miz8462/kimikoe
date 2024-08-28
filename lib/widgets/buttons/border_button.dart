import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';

class BorderButton extends StyledButton {
  const BorderButton(
    super.text, {
    required super.isSending,
    super.onPressed,
    super.textColor = textGray,
    super.backgroundColor = backgroundWhite,
    super.buttonSize,
    super.width,
    super.borderSide = const BorderSide(
      color: backgroundLightBlue,
      width: borderWidth,
    ),
    super.key,
  });
}
