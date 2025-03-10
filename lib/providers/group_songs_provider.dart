import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:kimikoe_app/providers/groups_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';

final groupSongsProvider =
    FutureProvider.family<List<Song>, int>((ref, groupId) async {
  try {
    await ref.watch(artistsFromSupabaseProvider.future);
    
    final group = ref.watch(groupsProvider.notifier).getGroupById(groupId);
    if (group == null) {
      throw StateError('グループが見つかりません: ID $groupId');
    }

    final groupName = group.name;
    logger.i('Supabaseから $groupName の曲リストを取得中...');
    final response = await supabase
        .from(TableName.songs)
        .select()
        .eq(ColumnName.groupId, groupId);

    final songs = <Song>[];

    for (final song in response) {
      try {
        final lyricist =
            ref.read(artistByIdProvider(song[ColumnName.lyricistId]));
        final composer =
            ref.read(artistByIdProvider(song[ColumnName.composerId]));

        songs.add(
          Song(
            id: song[ColumnName.id],
            title: song[ColumnName.title],
            lyrics: song[ColumnName.lyrics],
            group: group,
            movieUrl: song[ColumnName.movieUrl],
            imageUrl: song[ColumnName.imageUrl],
            lyricist: lyricist,
            composer: composer,
            releaseDate: song[ColumnName.releaseDate],
            comment: song[ColumnName.comment],
          ),
        );
      } catch (e) {
        // 個別の曲でエラーが発生しても、他の曲は処理を続ける
        logger.w(
          '曲「${song[ColumnName.title]}」の作成中にエラーが発生しました: $e',
        );
        continue;
      }
    }

    logger.i('Supabaseから $groupName の曲リストを取得しました。データ数は${songs.length}個です');
    return songs;
  } catch (e, stackTrace) {
    logger.e(
      'ID:$groupId の曲リストを取得中にエラーが発生しました',
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }
});
