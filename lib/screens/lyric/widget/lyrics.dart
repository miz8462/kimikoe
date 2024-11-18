import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
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
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final members = snapshot.data!;
            final memberList = members.map((member) {
              return {
                ColumnName.id: member[ColumnName.id],
                ColumnName.name: member[ColumnName.name],
                ColumnName.color: Color(int.parse(member[ColumnName.color])),
              };
            }).toList();

            final lyricsJson = jsonDecode(lyrics);

            return Row(children: [
              Expanded(
                child: Column(
                  children: [
                    for (var i = 0; i < lyricsJson.length; i++)
                      CustomTextForLyrics(
                        lyricsJson[i]['lyric'],
                        color: memberList.firstWhere((member) =>
                            member['id'] == lyricsJson[i]['singerId'])['color'],
                      ),
                  ],
                ),
              ),
            ]);
          }
        });
  }
}
