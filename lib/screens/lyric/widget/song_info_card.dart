import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/widgets/text/one_line_text.dart';

class SongInfoCard extends StatelessWidget {
  const SongInfoCard({
    required this.song,
    super.key,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 6,top: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OneLineText(
                    song.group!.name,
                    fontSize: fontM,
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OneLineText(
                        '作詞：${song.lyricist?.name ?? "不明"}',
                      ),
                      OneLineText(
                        '作曲：${song.composer?.name ?? "不明"}',
                      ),
                      OneLineText(
                        '発売日：${song.releaseDate ?? "不明"}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Image.network(
            song.imageUrl,
            height: 140,
            width: 140,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
