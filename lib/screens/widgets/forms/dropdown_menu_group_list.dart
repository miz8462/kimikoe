import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/dropdown_id_and_name.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({
    super.key,
    required this.label,
    required this.onSelected,
    required this.dataList,
  });

  final String label;
  final void Function(DropdownIdAndName?) onSelected;
  final List<Map<String, dynamic>> dataList;

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DropdownMenu<DropdownIdAndName>(
      // todo: 登録していないグループを入力した時のバリデーション。
      // todo: 自作のFilterCallbackが必要か？
      // enableFilter: true,
      enableSearch: true,
      requestFocusOnTap: true,
      label: Text(widget.label),
      width: screenWidth,
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        border: InputBorder.none,
        fillColor: backgroundLightBlue,
        filled: true,
      ),
      onSelected: (data) {
        widget.onSelected(data);
      },
      dropdownMenuEntries: widget.dataList.map((value) {
        return DropdownMenuEntry<DropdownIdAndName>(
          value: DropdownIdAndName(
            id: value[ColumnName.id.colname],
            name: value[ColumnName.name.colname],
          ),
          label: value[ColumnName.name.colname].toString(),
        );
      }).toList(),
    );
  }
}
