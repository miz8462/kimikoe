import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class ArtistListNotifier extends StateNotifier<List<Artist>> {
  ArtistListNotifier(super.state);

  Artist? getArtistById(int? id) {
    if (id == null) {
      return null;
    }
    return state.firstWhere((artist) => artist.id == id, orElse: () {
      throw StateError('Group with id:$id not found');
    });
  }
}

final artistListProvider =
    StateNotifierProvider<ArtistListNotifier, List<Artist>>((ref) {
  final asyncValue = ref.watch(artistListFromSupabaseProvider);
  return asyncValue.maybeWhen(
      data: (data) => ArtistListNotifier(data),
      orElse: () => ArtistListNotifier([]));
});

final artistListFromSupabaseProvider =
    FutureProvider<List<Artist>>((ref) async {
  final response = await fetchArtists();
  return response.map<Artist>((artist) {
    final imageUrl = fetchImageUrl(artist[ColumnName.imageUrl.name]);
    return Artist(
        id: artist[ColumnName.id.name],
        name: artist[ColumnName.cName.name],
        imageUrl: imageUrl,
        comment: artist[ColumnName.comment.name]);
  }).toList();
});
