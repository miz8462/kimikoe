import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';

final songListOfGroupProvider =
    FutureProvider.family<List<Song>, int>((ref, groupId) async {
  final group = ref.watch(idolGroupListProvider.notifier).getGroupById(groupId);

  final artistList = ref.watch(artistListProvider.notifier);

  final response = await supabase
      .from(TableName.songs.name)
      .select()
      .eq(ColumnName.groupId.name, groupId);
  return response.map((song) {
    final lyricist = artistList.getArtistById(song[ColumnName.lyricistId.name]);
    final composer = artistList.getArtistById(song[ColumnName.composerId.name]);
    return Song(
      id: song[ColumnName.id.name],
      title: song[ColumnName.title.name],
      lyrics: song[ColumnName.lyrics.name],
      group: group,
      imageUrl: song[ColumnName.imageUrl.name],
      lyricist: lyricist,
      composer: composer,
      releaseDate: song[ColumnName.releaseDate.name],
      comment: song[ColumnName.comment.name],
    );
  }).toList();
});
