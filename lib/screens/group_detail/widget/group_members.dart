import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class GroupMembers extends StatefulWidget {
  const GroupMembers({
    super.key,
    required this.group,
  });
  final IdolGroup group;
  @override
  State<GroupMembers> createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  late Future _memberFuture;
  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() {
    _memberFuture = fetchGroupMemberbyStream(
        table: TableName.idol.name,
        column: ColumnName.groupId.name,
        id: widget.group.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'メンバー',
            style: TextStyle(fontSize: fontM),
          ),
          Gap(spaceS),
          FutureBuilder(
            future: _memberFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.toString().length == 2) {
                return Center(child: Text('登録データはありません'));
              }
              final memberList = snapshot.data as List;
              return Expanded(
                child: ListView.builder(
                  itemCount: memberList.length,
                  itemBuilder: (context, index) {
                    final idol = Idol(
                      id: memberList[index][ColumnName.id.name],
                      name: memberList[index][ColumnName.cName.name],
                      imageUrl: memberList[index][ColumnName.imageUrl.name],
                      color: Color(
                        int.parse(memberList[index][ColumnName.color.name]),
                      ),
                      birthDay: memberList[index][ColumnName.birthday.name],
                      comment: memberList[index][ColumnName.comment.name],
                      debutYear: memberList[index][ColumnName.debutYear.name],
                      group: widget.group,
                      height: memberList[index][ColumnName.height.name],
                      hometown: memberList[index][ColumnName.hometown.name],
                      instagramUrl: memberList[index]
                          [ColumnName.instagramUrl.name],
                      officialUrl: memberList[index]
                          [ColumnName.officialUrl.name],
                      twitterUrl: memberList[index][ColumnName.twitterUrl.name],
                    );
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(RoutingPath.idolDetail,
                                extra: idol);
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                    borderRadius: borderRadius12,
                                    color: idol.color),
                              ),
                              Gap(spaceS),
                              Text(
                                idol.name,
                                style: TextStyle(fontSize: fontS),
                              ),
                            ],
                          ),
                        ),
                        Gap(spaceSS),
                      ],
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
