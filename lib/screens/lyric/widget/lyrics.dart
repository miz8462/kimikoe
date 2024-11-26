import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/utils/error_handling.dart';
import 'package:kimikoe_app/widgets/custom_text_for_lyrics.dart';

class Lyrics extends StatelessWidget {
  const Lyrics({
    super.key,
    required this.lyrics,
    required this.memberFuture,
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
            for (var member in members)
              member[ColumnName.id]: Color(int.parse(member[ColumnName.color]))
          };

          final lyricsJson = jsonDecode(lyrics);

          return Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    for (var lyric in lyricsJson)
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
