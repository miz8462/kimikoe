import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    this.hintText = '',
    super.key,
  });

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundLightBlue,
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: textGray),
          contentPadding: const EdgeInsets.only(left: spaceWidthS),
        ),
        controller: TextEditingController(),
      ),
    );
  }
}
