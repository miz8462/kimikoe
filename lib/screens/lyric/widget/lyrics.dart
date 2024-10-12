import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
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
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final members = snapshot.data!;
            final memberList = members.map((member) {
              return {
                ColumnName.id.name: member[ColumnName.id.name],
                ColumnName.cName.name: member[ColumnName.cName.name],
                ColumnName.color.name:
                    Color(int.parse(member[ColumnName.color.name])),
              };
            }).toList();

            final lyricsJson = jsonDecode(lyrics);

            return Row(children: [
              Column(
                children: [
                  for (var i = 0; i < lyricsJson.length; i++)
                    CustomTextForLyrics(
                      lyricsJson[i]['lyric'],
                      color: memberList.firstWhere((member) =>
                          member['id'] == lyricsJson[i]['singerId'])['color'],
                    ),
                ],
              ),
            ]);
          }
        });
  }
}
