import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
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

  Color parseColor(String colorStr) {
    try {
      return Color(int.parse(colorStr));
    } catch (e) {
      logger.e('Invalid color value: $colorStr, using default');
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: memberFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return handleMemberFetchError(snapshot.error);
        } else {
          final members = snapshot.data!;
          final memberData = {
            for (final member in members)
              member[ColumnName.id].toString(): {
                // キーを文字列に統一
                'name': member[ColumnName.name] as String? ?? 'Unknown',
                'color': parseColor(member[ColumnName.color] as String? ?? '0'),
              },
          };
          logger.d('Member Data: $memberData');

          final lyricsJson = jsonDecode(lyrics) as List;
          final validLyrics =
              lyricsJson.whereType<Map<String, dynamic>>().toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: validLyrics.length,
            itemBuilder: (context, index) {
              final lyric = validLyrics[index];
              if (lyric['lyric'] is String && lyric['singerIds'] is List) {
                final singerIds = lyric['singerIds'] as List<dynamic>;
                final singerInfos = singerIds.map((id) {
                  final singerId = id.toString();
                  logger.d('Processing lyric with singerId: $singerId');
                  return memberData[singerId] ??
                      {'name': 'Unknown Singer', 'color': Colors.black};
                }).toList();

                // 複数のシンガーの名前と色のリストを作成
                final names =
                    singerInfos.map((info) => info['name']! as String).toList();
                final colors =
                    singerInfos.map((info) => info['color']! as Color).toList();

                return Column(
                  children: [
                    CustomTextForLyrics(
                      lyric['lyric'] as String,
                      names: names, // シンガーの名前リスト
                      colors: colors, // シンガーの色リスト
                    ),
                    Gap(12),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          );
        }
      },
    );
  }
}
