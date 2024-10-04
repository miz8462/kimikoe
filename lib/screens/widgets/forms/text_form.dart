import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    this.hintText,
    super.key,
  });

  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonS,
      color: backgroundLightBlue,
      child: TextFormField(
        decoration: InputDecoration(
          border: noBorder,
          hintText: hintText,
          hintStyle: const TextStyle(color: textGray, fontSize: fontM),
          contentPadding:
              const EdgeInsets.only(left: spaceS, bottom: bottomPadding),
        ),
        controller: TextEditingController(),
      ),
    );
  }
}
