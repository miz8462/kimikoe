import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/song.dart';

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
              padding: const EdgeInsets.only(left: 10, bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.group!.name,
                    style: TextStyle(
                      fontSize: fontM,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const Spacer(),
                  Text(
                    '作詞：${song.lyricist?.name ?? "不明"}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '作曲：${song.composer?.name ?? "不明"}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '発売日：${song.releaseDate ?? "不明"}',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
