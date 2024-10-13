import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/widgets/styled_text.dart';

class SongInfoCard extends StatelessWidget {
  const SongInfoCard({
    super.key,
    required this.song,
  });
  final Song song;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: const BoxDecoration(color: backgroundLightBlue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  song.group!.name,
                  fontSize: fontL,
                ),
                const Spacer(),
                if (song.lyricist == null || song.lyricist!.name.isEmpty)
                  const StyledText(
                    '作詞：不明',
                    fontSize: fontS,
                  )
                else
                  StyledText(
                    '作詞：${song.lyricist!.name}',
                    fontSize: fontS,
                  ),
                if (song.composer == null || song.composer!.name.isEmpty)
                  const StyledText(
                    '作曲：不明',
                    fontSize: fontS,
                  )
                else
                  StyledText(
                    '作曲：${song.composer!.name}',
                    fontSize: fontS,
                  ),
                if (song.releaseDate == null || song.releaseDate!.isEmpty)
                  const StyledText(
                    '発売日：不明',
                    fontSize: fontS,
                  )
                else
                  StyledText(
                    '発売日：${song.releaseDate}',
                    fontSize: fontS,
                  ),
              ],
            ),
          ),
          Image.network(
            song.imageUrl!,
            height: 140,
          ),
        ],
      ),
    );
  }
}
