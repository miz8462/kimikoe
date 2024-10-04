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
          return AlertDialog(
            title: Text('本当に削除しますか？'),
            content: Text('削除したデータは復元できません。\nそれでも削除しますか？'),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteDataFromTable(
                      TableName.idolGroups.name,
                      ColumnName.id.name,
                      (widget.group.id).toString(),
                    );

                    if (!mounted) {
                      return;
                    }
                    Navigator.of(context).pop();
                    context.goNamed(RoutingPath.groupList);
                  },
                  child: Text(
                    'はい',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'いいえ',
                  ))
            ],
          );
        });
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
          hasEditingMode: true,
          deleteGroup: _deleteGroup,
          data: data),
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
                          name: memberList[index][ColumnName.cName.name],
                          color: Color(int.parse(
                              memberList[index][ColumnName.color.name])),
                        );
                        return Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  // color: idol.color,
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
                            Gap(spaceSS),
                          ],
                        );
                      }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
