import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class ExpandedTextForm extends StatelessWidget {
  const ExpandedTextForm({
    this.label,
    super.key,
    this.controller,
  });

  final String? label;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: backgroundLightBlue,
        child: TextFormField(
          decoration: InputDecoration(
            border: noBorder,
            label: Text(label!),
            hintStyle: const TextStyle(color: textGray, fontSize: fontM),
            contentPadding:
                const EdgeInsets.only(left: spaceWidthS, bottom: bottomPadding),
          ),
          maxLines: null,
          controller: controller,
        ),
      ),
    );
  }
}
