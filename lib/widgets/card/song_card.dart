import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/text/one_line_text.dart';

class SongCard extends ConsumerWidget {
  const SongCard({
    required this.song,
    required this.group,
    this.imageProvider,
    this.isFavoriteScreen = false,
    super.key,
  });
  final Song song;
  final IdolGroup group;
  final ImageProvider? imageProvider;
  final bool isFavoriteScreen;

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
      key: Key(WidgetKeys.songCard),
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
                  if (isFavoriteScreen) OneLineText(group.name),
                  OneLineText(
                    title,
                    fontSize: fontM,
                  ),
                  OneLineText(
                    allLyrics,
                    fontSize: fontSS,
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
