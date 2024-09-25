import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo({
    super.key,
    required this.group,
  });
  final IdolGroup group;

  @override
  Widget build(BuildContext context) {
    final groupName = group.name;
    final groupImage = group.imageUrl;
    final groupInfo = group.comment;
    return Card(
      elevation: 6,
      color: backgroundLightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius4,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: CircleAvatar(
              backgroundImage: NetworkImage(groupImage!),
              radius: avaterSizeL,
            ),
          ),
          Gap(spaceWidthL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: TextStyle(
                    fontSize: fontLL,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
                Text(
                  groupInfo ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSS,
                    color: textDark,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
