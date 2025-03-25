import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/widget_keys.dart';

class TextFormWithController extends StatelessWidget {
  const TextFormWithController({
    required this.label,
    required this.validator,
    required this.onSaved,
    required this.controller,
    this.focusNode,
    super.key,
  });
  final String label;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundLightBlue,
      child: TextFormField(
        key: Key(WidgetKeys.lyric),
        focusNode: focusNode,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(label),
          hintStyle: const TextStyle(color: textGray),
          contentPadding: const EdgeInsets.only(left: spaceS),
        ),
        autovalidateMode: AutovalidateMode.always,
        keyboardType: TextInputType.multiline,
        autocorrect: false,
        validator: validator,
        onSaved: onSaved,
        maxLines: null,
      ),
    );
  }
}
