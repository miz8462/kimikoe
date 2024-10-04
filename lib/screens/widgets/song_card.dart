import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    super.key,
    required this.songData,
  });
  final Map<String, dynamic> songData;

  @override
  Widget build(BuildContext context) {
    final song = Song(
      title: songData[ColumnName.title.name],
      groupId: songData[ColumnName.groupId.name],
      lyrics: songData[ColumnName.lyrics.name],
      imageUrl: songData[ColumnName.imageUrl.name],
    );
    final songImage = fetchPublicImageUrl(song.imageUrl!);
    final title = song.title;
    final lyrics = song.lyrics;
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
            Padding(
              padding: const EdgeInsets.all(4),
              child: CircleAvatar(
                backgroundImage: NetworkImage(songImage),
                radius: avaterSizeM,
              ),
            ),
            Gap(spaceL),
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
