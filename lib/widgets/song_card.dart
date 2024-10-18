import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class SongCard extends StatefulWidget {
  const SongCard({
    super.key,
    required this.song,
    required this.group,
  });
  final Song song;
  final IdolGroup group;

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  late Future<void> _artistFuture;
  Artist? _lyricist;
  Artist? _composer;
  @override
  void initState() {
    super.initState();
    _artistFuture = _fetchArtist();
  }

  Future<void> _fetchArtist() async {
    final song = widget.song;
    Map<String, dynamic>? lyricistData;
    Map<String, dynamic>? composerData;
    String? lyricistName;
    String? composerName;
    if (song.lyricist != null) {
      lyricistData = await supabase
          .from(TableName.artists.name)
          .select()
          .eq(ColumnName.id.name, song.lyricist!.id!)
          .single();
      lyricistName = lyricistData[ColumnName.cName.name];
    }
    if (song.composer != null) {
      composerData = await supabase
          .from(TableName.artists.name)
          .select()
          .eq(ColumnName.id.name, song.composer!.id!)
          .single();
      composerName = composerData[ColumnName.cName.name];
    }

    setState(() {
      if (lyricistName != null) {
        _lyricist = Artist(name: lyricistData?[ColumnName.cName.name]);
      }
      if (composerName != null) {
        _composer = Artist(name: composerData?[ColumnName.cName.name]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _artistFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final song = widget.song;
          final group = widget.group;

          final title = song.title;
          final lyrics = song.lyrics;

          // 一行ごとの歌詞と歌手のjsonから歌詞だけを抽出
          final lyricsJson = jsonDecode(lyrics);
          var allLyrics = '';
          for (var lyric in lyricsJson) {
            allLyrics += (lyric['lyric'] + ' ');
          }

          final data = {
            'song': song,
            'group': group,
          };

          return GestureDetector(
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
                      backgroundImage: NetworkImage(song.imageUrl!),
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
      },
    );
  }
}
