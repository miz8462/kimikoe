import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/buttons/styled_button.dart';

class GroupDetail extends StatefulWidget {
  const GroupDetail({
    super.key,
    required this.group,
  });

  final IdolGroup group;

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  late Future _memberFuture;
  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  void _loadMembers() {
    _memberFuture = supabase
        .from(TableName.idol.name)
        .select()
        .eq(ColumnName.groupId.colname, widget.group.id!);
  }

  @override
  Widget build(BuildContext context) {
    const String editButtonText = '編集する';
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
                  editButtonText,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text('優花ちゃん💙'),
                        );
                      },
                    );
                    // todo: グループ編集ページへ
                    // context.pushNamed(
                    //     RoutingPath.editGroup,
                    //     extra: group);
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
            Text(widget.group.comment!),
            Gap(spaceWidthS),
            // todo: メンバー表示。グループIDに一致するアイドルを表示する
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
                          name: memberList[index][ColumnName.name.colname],
                          color: Color(int.parse(
                              memberList[index][ColumnName.color.colname])),
                        );

                        return Row(
                          children: [
                            Container(
                              color: idol.color,
                              height: 20,
                              width: 20,
                            ),
                            Text(idol.name),
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
