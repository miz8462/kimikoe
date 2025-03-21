import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:kimikoe_app/providers/favorite/favorite_provider.dart';
import 'package:kimikoe_app/providers/groups_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_songs_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Song>> favoriteSongs(Ref ref) async {
  final favoriteIdsAsync =
      ref.watch(favoriteNotifierProvider(FavoriteType.songs));
  final favoriteIds = favoriteIdsAsync.value ?? [];

  if (favoriteIds.isEmpty) return [];
  try {
    final response = await supabase
        .from(TableName.songs)
        .select()
        .inFilter(ColumnName.id, favoriteIds);

    final songs = response.map<Song>((song) {
      final group = ref
          .read(groupsProvider.notifier)
          .getGroupById(song[ColumnName.groupId]);
      final lyricist =
          ref.read(artistByIdProvider(song[ColumnName.lyricistId]));
      final composer =
          ref.read(artistByIdProvider(song[ColumnName.composerId]));

      return Song(
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
      );
    }).toList();
    return songs;
  } catch (e) {
    logger.e('お気に入りグループの取得中にエラーが発生しました', error: e);
    return [];
  }
}
