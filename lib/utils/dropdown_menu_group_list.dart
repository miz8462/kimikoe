import 'package:flutter/material.dart';
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
    return FutureBuilder(
      future: widget.groupList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownMenu<IdolGroup>(
            enableFilter: true,
            enableSearch: true,
            requestFocusOnTap: true,
            label: Text('所属グループ'),
            dropdownMenuEntries: snapshot.data!.map((group) {
              return DropdownMenuEntry<IdolGroup>(
                value: IdolGroup(
                  id: group['id'],
                  name: group['name'],
                ),
                label: group['name'].toString(),
              );
            }).toList(),
            onSelected: (data) {
              widget.onGroupSelected(data);
            },
          );
        }
        return Text('data');
      },
    );
  }
}
