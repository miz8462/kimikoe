import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class InputForm extends StatelessWidget {
  const InputForm({
    super.key,
    required this.label,
    required this.validator,
    required this.onSaved,
  });

  final String label;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundLightBlue,
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(label),
          hintStyle: TextStyle(color: textGray),
          contentPadding: EdgeInsets.only(left: spaceWidthS),
        ),
        keyboardType: TextInputType.number,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
