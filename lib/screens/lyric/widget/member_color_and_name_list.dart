import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';

class GroupColorAndNameList extends StatefulWidget {
  const GroupColorAndNameList({
    super.key,
    required this.group,
    required this.memberFuture,
  });
  final IdolGroup group;
  final Future<List<Map<String, dynamic>>> memberFuture;

  @override
  State<GroupColorAndNameList> createState() => _GroupColorAndNameListState();
}

class _GroupColorAndNameListState extends State<GroupColorAndNameList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.memberFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final members = snapshot.data!;
          return Row(
            children: members.map<Widget>((member) {
              final color = Color(int.parse(member[ColumnName.color]));
              final name = member[ColumnName.name];
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
                  const Gap(spaceSS),
                  Text(name),
                  const Gap(spaceM),
                ],
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('No members found'));
        }
      },
    );
  }
}
