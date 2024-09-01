import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class ExpandedTextForm extends StatefulWidget {
  const ExpandedTextForm({
    super.key,
    this.label,
    required this.onTextChanged,
  });

  final String? label;
  final ValueChanged<String?> onTextChanged;

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
        decoration: InputDecoration(
          border: noBorder,
          label: Text(widget.label!),
          hintStyle: const TextStyle(color: textGray, fontSize: fontM),
          contentPadding:
              const EdgeInsets.only(left: spaceWidthS, bottom: bottomPadding),
        ),
        maxLines: null,
        onSaved: (value) {
          setState(() {
            _enteredText = value!;
          });
          widget.onTextChanged(_enteredText);
        },
      ),
    );
  }
}
