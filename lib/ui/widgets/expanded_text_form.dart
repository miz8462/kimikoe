import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

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
            hintStyle:
                const TextStyle(color: textGray, fontSize: fontM),
            contentPadding:
                const EdgeInsets.only(left: spaceWidthS, bottom: bottomPadding),
          ),
          controller: TextEditingController(),
          maxLines: null,
        ),
      ),
    );
  }
}
