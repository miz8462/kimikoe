// ignore_for_file: lines_longer_than_80_chars

import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_provider.g.dart';

enum FavoriteType { groups, songs }

@Riverpod(keepAlive: true)
class FavoriteNotifier extends _$FavoriteNotifier {
  final _userId = supabase.auth.currentUser!.id;
  late final String _tableName;
  late final String _columnId;
  late final FavoriteType _type;

  @override
  Future<List<int>> build(FavoriteType type) async {
    _type = type;
    _tableName = type == FavoriteType.groups
        ? TableName.favoriteGroups
        : TableName.favoriteSongs;
    _columnId =
        type == FavoriteType.groups ? ColumnName.groupId : ColumnName.songId;

    return _fetchFavorites();
  }

  Future<List<int>> _fetchFavorites() async {
    try {
      final response = await supabase
          .from(_tableName)
          .select()
          .eq(ColumnName.userId, _userId);
      return response.map((item) => item[_columnId] as int).toList();
    } catch (e) {
      logger.e(
        'お気に入り${_type == FavoriteType.groups ? "グループ" : "曲"}を取得中にエラーが発生しました',
        error: e,
      );
      return [];
    }
  }

  Future<void> fetchFavorites() async {
    state = const AsyncValue.loading();
    try {
      final newFavorites = await _fetchFavorites();
      state = AsyncValue.data(newFavorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> add(int groupId) async {
    // ローカル状態を仮更新(楽観的更新。とりあえず先にローカルの環境を更新)
    final previousState = state.value ?? [];
    state = AsyncData([...previousState, groupId]);

    // DB処理
    try {
      await supabase
          .from(_tableName)
          .insert({ColumnName.userId: _userId, _columnId: groupId});
    } catch (e) {
      // 失敗したら状態を元に戻す
      state = AsyncData(previousState);
      print(
        'お気に入り${_type == FavoriteType.groups ? "グループ" : "曲"}を追加中にエラーが発生しました: $e',
      );
      rethrow; // UI側でエラーをハンドリングしたい場合
    }
  }

  Future<void> remove(int groupId) async {
    // ローカル状態を仮更新
    final previousState = state.value ?? [];
    state = AsyncData(previousState.where((id) => id != groupId).toList());

    try {
      // Supabaseから削除
      await supabase
          .from(_tableName)
          .delete()
          .eq(ColumnName.userId, _userId)
          .eq(_columnId, groupId);
    } catch (e) {
      // 失敗したら状態を元に戻す
      state = AsyncData(previousState);
      print(
        'お気に入り${_type == FavoriteType.groups ? "グループ" : "曲"}を削除中にエラーが発生しました: $e',
      );
      rethrow;
    }
  }
}
