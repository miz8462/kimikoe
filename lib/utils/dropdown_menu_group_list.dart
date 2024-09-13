import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/tables.dart';
import 'package:kimikoe_app/models/idol_group.dart';

class DropdownMenuGroupList extends StatefulWidget {
  const DropdownMenuGroupList({
    super.key,
    required this.onGroupSelected,
    required this.groupList,
  });
  final void Function(IdolGroup?) onGroupSelected;
  final Future<List<Map<String, dynamic>>> groupList;

  @override
  State<DropdownMenuGroupList> createState() => _DropdownMenuGroupListState();
}

class _DropdownMenuGroupListState extends State<DropdownMenuGroupList> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: widget.groupList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('エラーが発生しました: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('データがありません');
        } else {
          return DropdownMenu<IdolGroup>(
            // todo: 自作のFilterCallbackが必要か？
            // enableFilter: true,
            enableSearch: true,
            requestFocusOnTap: true,
            label: Text('グループ'),
            width: screenWidth * 2 / 3,
            inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none,
              fillColor: backgroundLightBlue,
              filled: true,
            ),
            dropdownMenuEntries: snapshot.data!.map((group) {
              return DropdownMenuEntry<IdolGroup>(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(backgroundLightBlue),
                ),
                value: IdolGroup(
                  id: group[ColumnName.id.colname],
                  name: group[ColumnName.name.colname],
                ),
                label: group[ColumnName.name.colname].toString(),
              );
            }).toList(),
            onSelected: (data) {
              widget.onGroupSelected(data);
            },
          );
        }
      },
    );
  }
}
