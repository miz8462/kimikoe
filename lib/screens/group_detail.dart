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
import 'package:kimikoe_app/screens/widgets/buttons/styled_button.dart';

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

  @override
  Widget build(BuildContext context) {
    const double buttonWidth = 180;

    return Scaffold(
      appBar: TopBar(title: widget.group.name),
      body: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(spaceWidthS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.group.imageUrl!),
                  radius: avaterSizeL,
                ),
                StyledButton(
                  '編集する',
                  onPressed: () {
                    // todo: グループ編集ページへ
                    final data = {
                      'group': widget.group,
                      'isEditing': isEditing,
                    };
                    context.pushNamed(RoutingPath.addGroup, extra: data);
                  },
                  textColor: textGray,
                  backgroundColor: backgroundWhite,
                  buttonSize: buttonM,
                  borderSide: BorderSide(
                      color: backgroundLightBlue, width: borderWidth),
                  width: buttonWidth,
                ),
              ],
            ),
            Gap(spaceWidthS),
            Text(
              widget.group.comment!,
              style: TextStyle(fontSize: fontS),
            ),
            Gap(spaceWidthS),
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
            Gap(spaceWidthS),
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
                                Gap(spaceWidthS),
                                Text(
                                  idol.name,
                                  style: TextStyle(fontSize: fontS),
                                ),
                              ],
                            ),
                            Gap(spaceWidthSS),
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
