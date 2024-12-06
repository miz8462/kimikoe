import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class ExpandedTextForm extends StatefulWidget {
  const ExpandedTextForm({
    required this.onTextChanged, super.key,
    this.label,
    this.initialValue,
  });

  final String? label;
  final ValueChanged<String?> onTextChanged;
  final String? initialValue;

  @override
  State<ExpandedTextForm> createState() => _ExpandedTextFormState();
}

class _ExpandedTextFormState extends State<ExpandedTextForm> {
  String? _enteredText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: backgroundLightBlue,
      child: TextFormField(
        initialValue: widget.initialValue,
        decoration: InputDecoration(
          border: noBorder,
          label: Text(widget.label!),
          hintStyle: const TextStyle(color: textGray, fontSize: fontM),
          contentPadding:
              const EdgeInsets.only(left: spaceS, bottom: bottomPadding),
        ),
        maxLines: null,
        onSaved: (value) {
          _enteredText = value;
          widget.onTextChanged(_enteredText);
        },
      ),
    );
  }
}
