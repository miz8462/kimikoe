import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo({super.key, required this.group});
  final IdolGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(group.imageUrl!),
          radius: avaterSizeLL,
        ),
        Gap(spaceS),
        if (group.comment != null)
          Text(
            group.comment!,
            style: TextStyle(fontSize: fontS),
          ),
        Gap(spaceS),
        if (group.year == null) Text('結成年：不明') else Text('結成年：${group.year}'),
      ],
    );
  }
}
