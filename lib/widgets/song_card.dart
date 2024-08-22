import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const songImage = 'assets/images/poison_palette.jpg';
    const title = 'Sound Paradise';
    return GestureDetector(
      onTap: () =>
          context.push('${RoutingPath.groupList}/${RoutingPath.lyric}'),
      child: Card(
        elevation: 6,
        color: backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          children: [
            // 曲のイメージ。ジャケット。
            CircleAvatar(
              backgroundImage: AssetImage(songImage),
              radius: avaterSizeM,
            ),
            Gap(spaceWidthL),
            // 曲名
            Text(
              title,
              style: TextStyle(
                fontSize: fontM,
                fontWeight: FontWeight.w400,
                color: textDark,
              ),
            )
          ],
        ),
      ),
    );
  }
}
