import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class InputForm extends StatelessWidget {
  const InputForm({
    required this.label, required this.onSaved, super.key,
    this.validator,
    this.initialValue,
    this.keyboardType = TextInputType.text,
  });

  final String label;
  final String? Function(String?)? validator;
  final void Function(String?) onSaved;
  final String? initialValue;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundLightBlue,
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(label),
          hintStyle: const TextStyle(color: textGray),
          contentPadding: const EdgeInsets.only(left: spaceS),
        ),
        keyboardType: keyboardType,
        autocorrect: false,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
