import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class DrumRollForm extends StatefulWidget {
  const DrumRollForm({
    super.key,
    required this.label,
    this.selectedNum,
    required this.controller,
    required this.picker,
    required this.onSaved,
  });

  final String label;
  final String? selectedNum;
  final TextEditingController controller;
  final void Function() picker;
  final void Function(String?) onSaved;
  @override
  State<DrumRollForm> createState() => _DrumRollFormState();
}

class _DrumRollFormState extends State<DrumRollForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundLightBlue,
      child: TextFormField(
        controller: widget.controller,
        onTap: widget.picker,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: Text(widget.label),
          hintStyle: TextStyle(color: textGray),
          contentPadding: EdgeInsets.only(left: spaceWidthS),
        ),
        readOnly: true,
        onSaved: widget.onSaved,
      ),
    );
    ;
  }
}
