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
                  fontSize: fontM,
                ),
                const Spacer(),
                if (song.lyricist == null || song.lyricist!.name.isEmpty)
                  const StyledText('作詞：不明')
                else
                  StyledText('作詞：${song.lyricist!.name}'),
                if (song.composer == null || song.composer!.name.isEmpty)
                  const StyledText('作曲：不明')
                else
                  StyledText('作曲：${song.composer!.name}'),
                if (song.releaseDate == null || song.releaseDate!.isEmpty)
                  const StyledText('発売日：不明')
                else
                  StyledText('発売日：${song.releaseDate}'),
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
