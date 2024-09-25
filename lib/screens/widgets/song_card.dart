import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    super.key,
  });
  // songData;

  @override
  Widget build(BuildContext context) {
    final songImage = 'assets/images/poison_palette.jpg';
    final title = 'Sound Paradise';
    final lyrics = '聞こえるかい？';
    return GestureDetector(
      onTap: () =>
          context.push('${RoutingPath.groupList}/${RoutingPath.lyric}'),
      child: Card(
        elevation: 6,
        color: backgroundWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(songImage),
              radius: avaterSizeM,
            ),
            Gap(spaceWidthL),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontM,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                  ),
                ),
                Text(
                  lyrics,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSS,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
