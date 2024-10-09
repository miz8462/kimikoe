import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/widgets/styled_text.dart';

class SongInfoCard extends StatelessWidget {
  const SongInfoCard({
    super.key,
    required this.song,
  });
  final Song song;

  @override
  Widget build(BuildContext context) {
    final imageUrl = fetchPublicImageUrl(song.imageUrl!);
    return Container(
      height: 140,
      decoration: BoxDecoration(color: backgroundLightBlue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  song.title,
                  fontSize: fontL,
                ),
                // アーティスト
                StyledText(
                  song.group!.name,
                  fontSize: fontS,
                ),
                Spacer(),
                if (song.lyricist != null)
                  StyledText('作詞：${song.lyricist!.name}'),
                if (song.composer != null)
                  StyledText('作曲：${song.composer!.name}'),
                if (song.releaseDate != null)
                  StyledText('発売日：${song.releaseDate}'),
              ],
            ),
          ),
          Image.network(
            imageUrl,
            height: 140,
          ),
        ],
      ),
    );
  }
}
