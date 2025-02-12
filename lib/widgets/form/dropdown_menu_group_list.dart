import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/dropdown_id_and_name.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/widget_keys.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({
    required this.label,
    required this.dataList,
    required this.controller,
    super.key,
  });

  final String label;
  final List<Map<String, dynamic>> dataList;
  final TextEditingController controller;

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DropdownMenu<DropdownIdAndName>(
      controller: widget.controller,
      requestFocusOnTap: true,
      label: Text(widget.label),
      width: screenWidth,
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        border: InputBorder.none,
        fillColor: backgroundLightBlue,
        filled: true,
      ),
      dropdownMenuEntries: widget.dataList.map((value) {
        final id = value[ColumnName.id];
        final name = value[ColumnName.name];
        return DropdownMenuEntry<DropdownIdAndName>(
          value: DropdownIdAndName(
            key: Key(WidgetKeys.name),
            id: id,
            name: name,
          ),
          label: value[ColumnName.name].toString(),
        );
      }).toList(),
    );
  }
}
