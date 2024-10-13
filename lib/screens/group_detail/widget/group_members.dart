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
    _memberFuture = fetchGroupMembers(widget.group.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'メンバー',
            style: TextStyle(fontSize: fontM),
          ),
          const Gap(spaceS),
          FutureBuilder(
            future: _memberFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data.toString().length == 2) {
                return const Center(child: Text('登録データはありません'));
              }
              final memberList = snapshot.data as List;
              return Expanded(
                child: ListView.builder(
                  itemCount: memberList.length,
                  itemBuilder: (context, index) {
                    final idolData = memberList[index];
                    final imageUrl =
                        fetchPublicImageUrl(idolData[ColumnName.imageUrl.name]);

                    final idol = Idol(
                      id: idolData[ColumnName.id.name],
                      name: idolData[ColumnName.cName.name],
                      imageUrl: imageUrl,
                      color: Color(
                        int.parse(idolData[ColumnName.color.name]),
                      ),
                      birthYear: idolData[ColumnName.birthYear.name],
                      birthDay: idolData[ColumnName.birthday.name],
                      comment: idolData[ColumnName.comment.name],
                      debutYear: idolData[ColumnName.debutYear.name],
                      group: widget.group,
                      height: idolData[ColumnName.height.name],
                      hometown: idolData[ColumnName.hometown.name],
                      instagramUrl: idolData[ColumnName.instagramUrl.name],
                      officialUrl: idolData[ColumnName.officialUrl.name],
                      twitterUrl: idolData[ColumnName.twitterUrl.name],
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
                              const Gap(spaceS),
                              Text(
                                idol.name,
                                style: const TextStyle(fontSize: fontS),
                              ),
                            ],
                          ),
                        ),
                        const Gap(spaceSS),
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
