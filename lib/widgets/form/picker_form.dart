import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class PickerForm extends StatefulWidget {
  const PickerForm({
    required this.label,
    required this.controller,
    required this.picker,
    required this.onSaved,
    this.initialValue,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final void Function() picker;
  final void Function(String?) onSaved;
  final String? initialValue;

  @override
  State<PickerForm> createState() => _PickerFormState();
}

class _PickerFormState extends State<PickerForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.initialValue ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundLightBlue,
      child: TextFormField(
        controller: widget.controller,
        onTap: widget.picker,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(widget.label),
          hintStyle: const TextStyle(color: textGray),
          contentPadding: const EdgeInsets.only(left: spaceS),
        ),
        readOnly: true,
        onSaved: widget.onSaved,
      ),
    );
  }
}
