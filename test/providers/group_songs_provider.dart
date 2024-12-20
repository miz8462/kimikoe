import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';

final groupSongsProvider =
    FutureProvider.family<List<Song>, int>((ref, groupId) async {
  try {
    final group = ref
        .watch(idolGroupListProvider.notifier)
        .getGroupById(groupId, logger: logger);
    final groupName = group!.name;
    final artistList = ref.watch(artistListProvider.notifier);

    logger.i('Supabaseから $groupName の曲のリストを取得中...');
    final response = await supabase
        .from(TableName.songs)
        .select()
        .eq(ColumnName.groupId, groupId);
    final songs = response.map((song) {
      final lyricist = artistList.getArtistById(song[ColumnName.lyricistId]);
      final composer = artistList.getArtistById(song[ColumnName.composerId]);
      return Song(
        id: song[ColumnName.id],
        title: song[ColumnName.title],
        lyrics: song[ColumnName.lyrics],
        group: group,
        imageUrl: song[ColumnName.imageUrl],
        lyricist: lyricist,
        composer: composer,
        releaseDate: song[ColumnName.releaseDate],
        comment: song[ColumnName.comment],
      );
    }).toList();
    logger.i('Supabaseから $groupName の曲のリストを取得しました。曲数は${songs.length}曲です');
    return songs;
  } catch (e, stackTrace) {
    logger.e(
      'ID:$groupId の曲リストを取得中にエラーが発生しました',
      error: e,
      stackTrace: stackTrace,
    );
    return [];
  }
});
