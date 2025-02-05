import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class SongCard extends ConsumerWidget {
  const SongCard({
    required this.song,
    required this.group,
    this.imageProvider,
    super.key,
  });
  final Song song;
  final IdolGroup group;
  final ImageProvider? imageProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = song.title;
    final lyrics = song.lyrics;

    final image = imageProvider ?? NetworkImage(song.imageUrl);

    // 一行ごとの歌詞と歌手のjsonから歌詞だけを抽出
    final lyricsJson = jsonDecode(lyrics) as List<dynamic>;

    // bufferをつかうと早いらしい（analyzer談）
    final buffer = StringBuffer();
    for (final dynamic lyric in lyricsJson) {
      if (lyric is Map<String, dynamic> && lyric['lyric'] is String) {
        buffer.write('${lyric['lyric']} ');
      }
    }
    final allLyrics = buffer.toString().trim();

    final data = {
      'song': song,
      'group': group,
    };

    return GestureDetector(
      key: Key('song'),
      onTap: () => context.pushNamed(RoutingPath.lyric, extra: data),
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
                backgroundImage: image,
                radius: avaterSizeM,
              ),
            ),
            const Gap(spaceL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: fontM,
                      fontWeight: FontWeight.w400,
                      color: textDark,
                    ),
                  ),
                  Text(
                    allLyrics,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: fontSS,
                      fontWeight: FontWeight.w400,
                      color: textDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
