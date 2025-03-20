import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_songs_provider.g.dart';

@Riverpod(keepAlive: true)
class FavoriteSongsNotifier extends _$FavoriteSongsNotifier {
  @override
  List<int> build() {
    return [];
  }

  void add(int songId) {
    state = [...state, songId];
  }

  void remove(int songId) {
    state = state.where((id) => id != songId).toList();
  }
}
