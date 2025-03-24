import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/dropdown_id_and_name.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({
    required this.label,
    required this.dataList,
    required this.controller,
    this.isSelected = false,
    this.onSelectedChanged,
    super.key,
  });

  final String label;
  final List<Map<String, dynamic>> dataList;
  final TextEditingController controller;
  final bool isSelected;
  final void Function({required bool isSelected})? onSelectedChanged;

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant CustomDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      isSelected = widget.controller.text.isNotEmpty;
    }
  }

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
            id: id,
            name: name,
          ),
          label: value[ColumnName.name].toString(),
        );
      }).toList(),
      onSelected: (DropdownIdAndName? item) {
        setState(() {
          isSelected = item != null;
        });
        widget.onSelectedChanged?.call(isSelected: isSelected);
      },
    );
  }
}
