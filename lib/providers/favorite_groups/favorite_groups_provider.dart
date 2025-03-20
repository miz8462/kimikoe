import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_groups_provider.g.dart';

@Riverpod(keepAlive: true)
class FavoriteGroupsNotifier extends _$FavoriteGroupsNotifier {
  late String _userId;
  @override
  Future<List<int>> build() async {
    try {
      _userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from(TableName.favoriteGroups)
          .select('group_id')
          .eq('user_id', _userId);
      return response.map((item) => item['group_id'] as int).toList();
    } catch (e) {
      logger.e('お気に入りグループを取得中にエラーが発生しました', error: e);
      return [];
    }
  }

  Future<void> add(int groupId) async {
    // ローカルデータ更新
    final previousState = state.value ?? [];
    state = AsyncData([...previousState, groupId]);

    // DB処理
    try {
      await supabase
          .from('favorite_groups')
          .insert({'user_id': _userId, 'group_id': groupId});
    } catch (e) {
      // 失敗したら状態を元に戻す
      state = AsyncData(previousState);
      print('Error adding favorite group: $e');
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
          .from('favorite_groups')
          .delete()
          .eq('user_id', _userId)
          .eq('group_id', groupId);
    } catch (e) {
      // 失敗したら状態を元に戻す
      state = AsyncData(previousState);
      print('Error removing favorite group: $e');
      rethrow;
    }
  }
}
