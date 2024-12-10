import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class InputForm extends StatelessWidget {
  const InputForm({
    required this.label,
    required this.onSaved,
    this.initialValue,
    this.validator,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  final String label;
  final void Function(String?) onSaved;
  final String? initialValue;
  final String? Function(String?)? validator;
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
