import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';

final songListOfGroupProvider =
    FutureProvider.family<List<Song>, int>((ref, groupId) async {
  final group = ref.watch(idolGroupListProvider.notifier).getGroupById(groupId);

  final artistList = ref.watch(artistListProvider.notifier);

  final response = await supabase
      .from(TableName.songs)
      .select()
      .eq(ColumnName.groupId, groupId);
  return response.map((song) {
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
});
