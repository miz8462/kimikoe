// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_provider.g.dart';

enum FavoriteType { groups, songs }

@Riverpod(keepAlive: true)
class FavoriteNotifier extends _$FavoriteNotifier {
  FavoriteNotifier() {
    _ref = ref;
  }
  late Ref _ref;

  late final String _userId; // build時に初期化

  late final String _tableName;
  late final String _columnName;
  late final FavoriteType _type;

  @override
  Future<List<int>> build(FavoriteType type) async {
    _type = type;
    _tableName = type == FavoriteType.groups
        ? TableName.favoriteGroups
        : TableName.favoriteSongs;
    _columnName =
        type == FavoriteType.groups ? ColumnName.groupId : ColumnName.songId;

    final client = _ref.watch(supabaseProvider);
    if (client.auth.currentUser == null) {
      throw Exception('ユーザーがログインしていません');
    }

    _userId = client.auth.currentUser!.id;

    return _fetchFavorites();
  }

  Future<List<int>> _fetchFavorites() async {
    final supabaseServices = ref.read(supabaseServicesProvider);

    try {
      final response = await supabaseServices.fetch.fetchFavorites(
        tableName: _tableName,
        userId: _userId,
      );
      return response.map((item) => item[_columnName] as int).toList();
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

    final supabaseServices = ref.read(supabaseServicesProvider);

    // DB処理
    try {
      await supabaseServices.favorite.addFavorite(
        table: _tableName,
        userId: _userId,
        columnName: _columnName,
        groupId: groupId,
      );
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

    final supabaseServices = ref.read(supabaseServicesProvider);

    try {
      // Supabaseから削除
      await supabaseServices.favorite.removeFavorite(
        table: _tableName,
        userId: _userId,
        columnName: _columnName,
        groupId: groupId,
      );
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
