import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

const noBorder = InputBorder.none;

class ExpandedTextForm extends StatelessWidget {
  const ExpandedTextForm({
    this.hintText,
    super.key,
  });

  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: backgroundLightBlue,
        child: TextFormField(
          decoration: InputDecoration(
            border: noBorder,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: textGray,
              height: 0,
            ),
            contentPadding: const EdgeInsets.only(left: spaceWidthS),
          ),
          controller: TextEditingController(),
          maxLines: null,
        ),
      ),
    );
  }
}
