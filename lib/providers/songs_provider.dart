import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/providers/artists_provider.dart';
import 'package:kimikoe_app/providers/idol_groups_providere.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

final songsProvider =
    FutureProvider.family<List<Song>, int>((ref, groupId) async {
  final group = ref.watch(idolGroupListProvider.notifier).getGroupById(groupId);

  final artistList = ref.watch(artistListProvider.notifier);

  final response = await supabase
      .from(TableName.songs.name)
      .select()
      .eq(ColumnName.groupId.name, groupId);
  return response.map((song) {
    final imageUrl = fetchPublicImageUrl(song[ColumnName.imageUrl.name]);
    final lyricist = artistList.getArtistById(song[ColumnName.lyricistId.name]);
    final composer = artistList.getArtistById(song[ColumnName.composerId.name]);
    return Song(
      id: song[ColumnName.id.name],
      title: song[ColumnName.title.name],
      lyrics: song[ColumnName.lyrics.name],
      group: group,
      imageUrl: imageUrl,
      lyricist: lyricist,
      composer: composer,
      releaseDate: song[ColumnName.releaseDate.name],
      comment: song[ColumnName.comment.name],
    );
  }).toList();
});
