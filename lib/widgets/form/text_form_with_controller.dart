import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class TextFormWithController extends StatelessWidget {
  const TextFormWithController({
    required this.label,
    required this.validator,
    required this.onSaved,
    required this.controller,
    super.key,
  });
  final String label;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final TextEditingController controller;

  @override

  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundLightBlue,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(label),
          hintStyle: const TextStyle(color: textGray),
          contentPadding: const EdgeInsets.only(left: spaceS),
        ),
        keyboardType: TextInputType.multiline,
        autocorrect: false,
        validator: validator,
        onSaved: onSaved,
        maxLines: null,
      ),
    );
  }
}
