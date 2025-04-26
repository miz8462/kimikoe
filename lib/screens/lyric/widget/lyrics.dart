import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/providers/group_members_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/utils/error_handling.dart';
import 'package:kimikoe_app/widgets/text/custom_text_for_lyrics.dart';

class Lyrics extends ConsumerWidget {
  const Lyrics({
    required this.lyrics,
    required this.group,
    super.key,
  });

  final String lyrics;
  final IdolGroup group;

  Color parseColor(dynamic color) {
    if (color is Color) {
      return color; // すでにColorオブジェクトの場合はそのまま返す
    }
    if (color is String) {
      try {
        return Color(int.parse(color)); // 16進数カラーコードをパース
      } catch (e) {
        logger.e('Invalid color string: $color, using default');
      }
    }
    return Colors.black; // 無効な場合のフォールバック
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(groupMembersProvider(group.id!));

    return members.when(
      data: (members) {
        if (members.isEmpty) {
          return const Center(child: Text('No members found'));
        }

        // メンバーデータをマップに変換
        final memberData = {
          for (final member in members)
            member.id.toString(): {
              'name': member.name,
              'color': parseColor(member.color),
            },
        };
        logger.d('Member Data: $memberData');

        final lyricsJson = jsonDecode(lyrics) as List;
        final validLyrics =
            lyricsJson.whereType<Map<String, dynamic>>().toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: validLyrics.length,
          itemBuilder: (context, index) {
            final lyric = validLyrics[index];
            if (lyric['lyric'] is String) {
              // 歌詞は常に表示
              final singerIds = lyric['singerIds'] is List
                  ? lyric['singerIds'] as List<dynamic>
                  : <dynamic>[];
              // 歌手が未登録（singerIdsが空）の場合、singerInfosを空リストに
              final singerInfos = singerIds.isNotEmpty
                  ? singerIds.map((id) {
                      final singerId = id.toString();
                      return memberData[singerId] ??
                          {'name': 'Unknown Singer', 'color': Colors.black};
                    }).toList()
                  : <Map<String, dynamic>>[];

              // 名前と色のリストを作成（歌手未登録なら空）
              final names = singerInfos.map((Map<String, dynamic> info) {
                final name = info['name'];
                return name is String ? name : 'Unknown Singer';
              }).toList();
              final colors = singerInfos.map((Map<String, dynamic> info) {
                final color = info['color'];
                return color is Color ? color : Colors.black;
              }).toList();

              return Column(
                children: [
                  CustomTextForLyrics(
                    lyric['lyric'] as String,
                    names: names,
                    colors: colors,
                  ),
                  const Gap(12),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => handleMemberFetchError(error),
    );
  }
}
