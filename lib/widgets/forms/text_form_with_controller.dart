import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class TextFormWithController extends StatelessWidget {
  const TextFormWithController({
    super.key,
    required this.label,
    required this.validator,
    required this.onSaved,
    required this.controller,
  });
  final String label;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundLightBlue,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(label),
          hintStyle: TextStyle(color: textGray),
          contentPadding: EdgeInsets.only(left: spaceS),
        ),
        keyboardType: TextInputType.name,
        autocorrect: false,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
