import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';

class GroupCardWide extends StatelessWidget {
  const GroupCardWide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const groupImage = 'assets/images/poison_palette.jpg';
    const groupName = 'Poison Palette';
    const groupInfo = '聞きたくないが嘘になる“毒”創性！\nBreak&Popガールズグループ';
    return Card(
      elevation: 6,
      color: backgroundLightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius4,
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(groupImage),
            radius: avaterSizeL,
          ),
          Gap(spaceWidthL),
          Column(
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
                groupInfo,
                style: TextStyle(
                  fontSize: fontSS,
                  color: textDark,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
