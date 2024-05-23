import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const groupImage = 'assets/images/poison_palette.jpg';
    const groupName = 'Poison Palette';
    const groupInfo = '聞きたくないが嘘になる“毒”創性！\nBreak&Popガールズグループ';
    return Card(
      color: backgroundLightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(groupImage),
            radius: 32,
          ),
          Gap(spaceWidthL),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groupName,
                style: TextStyle(fontSize: fontLL, fontWeight: FontWeight.bold),
              ),
              Text(
                groupInfo,
                style: TextStyle(fontSize: fontSS),
              ),
            ],
          )
        ],
      ),
    );
  }
}
