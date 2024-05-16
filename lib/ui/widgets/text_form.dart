import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

const noBorder = InputBorder.none;

class TextForm extends StatelessWidget {
  const TextForm({
    this.hintText,
    super.key,
  });

  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundLightBlue,
      child: TextFormField(
        decoration: InputDecoration(
          border: noBorder,
          hintText: hintText,
          hintStyle: const TextStyle(color: textGray),
          contentPadding: const EdgeInsets.only(left: spaceWidthS),
        ),
        controller: TextEditingController(),
      ),
    );
  }
}
