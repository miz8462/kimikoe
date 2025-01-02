import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/utils/error_handling.dart';
import 'package:kimikoe_app/widgets/text/custom_text_for_lyrics.dart';

class Lyrics extends StatelessWidget {
  const Lyrics({
    required this.lyrics,
    required this.memberFuture,
    super.key,
  });
  final String lyrics;
  final Future<List<Map<String, dynamic>>> memberFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: memberFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return handleMemberFetchError(snapshot.error);
        } else {
          final members = snapshot.data!;
          final memberMap = {
            for (final member in members)
              member[ColumnName.id]: Color(int.parse(member[ColumnName.color])),
          };

          final lyricsJson = jsonDecode(lyrics) as List<dynamic>;

          return Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    for (final lyric in lyricsJson)
                      if (lyric is Map<String, dynamic> &&
                          lyric['lyric'] is String)
                        CustomTextForLyrics(
                          lyric['lyric'],
                          color: memberMap[lyric['singerId']],
                        ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
