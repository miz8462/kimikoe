import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/widgets/text/styled_text.dart';

class SongInfoCard extends StatelessWidget {
  const SongInfoCard({
    required this.song, super.key,
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
                  fontSize: fontM,
                ),
                const Spacer(),
                StyledText(
                  '作詞：${song.lyricist?.name ?? "作詞: 不明"}',
                ),
                StyledText(
                  '作曲：${song.composer?.name ?? "作曲: 不明"}',
                ),
                StyledText(
                  '発売日：${song.releaseDate ?? "発売日: 不明"}',
                ),
              ],
            ),
          ),
          Image.network(
            song.imageUrl!,
            height: 140,
            width: 140,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
