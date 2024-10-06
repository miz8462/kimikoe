import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/delete_alert_dialog.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({
    super.key,
    required this.group,
  });

  final IdolGroup group;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late Future _memberFuture;
  bool isEditing = true;
  bool isGroup = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() {
    _memberFuture = supabase
        .from(TableName.idol.name)
        .select()
        .eq(ColumnName.groupId.name, widget.group.id!);
  }

  void _deleteGroup() {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () {
            deleteDataFromTable(
              TableName.idolGroups.name,
              ColumnName.id.name,
              (widget.group.id).toString(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = {
      'group': widget.group,
      'isEditing': isEditing,
    };

    return Scaffold(
      appBar: TopBar(
        title: widget.group.name,
        hasEditingMode: isEditing,
        isGroup: isGroup,
        delete: _deleteGroup,
        data: data,
      ),
      body: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(spaceS),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.group.imageUrl!),
              radius: avaterSizeLL,
            ),
            Gap(spaceS),
            Text(
              widget.group.comment!,
              style: TextStyle(fontSize: fontS),
            ),
            Gap(spaceS),
            Text('結成年：${widget.group.year}'),
            // todo: メンバー表示。グループIDに一致するアイドルを表示する
            Divider(
              color: mainBlue.withOpacity(0.3),
              thickness: 2,
            ),
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
                        // birthDay: memberList[index][ColumnName.birthday.name],
                        comment: memberList[index][ColumnName.comment.name],
                        debutYear: memberList[index][ColumnName.debutYear.name],
                        groupId: memberList[index][ColumnName.groupId.name],
                        height: memberList[index][ColumnName.height.name],
                        hometown: memberList[index][ColumnName.hometown.name],
                        instagramUrl: memberList[index]
                            [ColumnName.instagramUrl.name],
                        officialUrl: memberList[index]
                            [ColumnName.officialUrl.name],
                        twitterUrl: memberList[index]
                            [ColumnName.twitterUrl.name],
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
      ),
    );
  }
}
