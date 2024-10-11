import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

const circleSize = 20.0;

class GroupColorAndNameList extends StatefulWidget {
  const GroupColorAndNameList({
    super.key,
    required this.group,
  });
  final IdolGroup group;

  @override
  State<GroupColorAndNameList> createState() => _GroupColorAndNameListState();
}

class _GroupColorAndNameListState extends State<GroupColorAndNameList> {
  late Future<List<Map<String, dynamic>>> _memberFuture;

  @override
  void initState() {
    super.initState();
    _memberFuture = loadMembers(widget.group.id!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _memberFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final members = snapshot.data!;
          return Row(
            children: members.map<Widget>((member) {
              final color = Color(int.parse(member[ColumnName.color.name]));
              final name = member[ColumnName.cName.name];
              return Row(
                children: [
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: color, // 好きな色を指定
                      shape: BoxShape.circle, // 円形を指定
                    ),
                  ),
                  Gap(spaceSS),
                  Text(name),
                  Gap(spaceM),
                ],
              );
            }).toList(),
          );
        } else {
          return Center(child: Text('No members found'));
        }
      },
    );
  }
}
