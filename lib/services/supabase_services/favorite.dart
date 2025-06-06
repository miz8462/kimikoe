import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Favorite {
  Favorite(this.client);
  final SupabaseClient client;

  Future<void> addFavorite({
    required String table,
    required String userId,
    required String columnName,
    required int groupId,
  }) async {
    try {
      await client.from(table).insert({
        ColumnName.userId: userId,
        columnName: groupId,
      });
    } catch (e) {
      logger.e('グループをお気に入りに追加中にエラーが発生しました: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite({
    required String table,
    required String userId,
    required String columnName,
    required int groupId,
  }) async {
    try {
      await client
          .from(table)
          .delete()
          .eq(ColumnName.userId, userId)
          .eq(columnName, groupId);
    } catch (e) {
      logger.e('お気に入りを削除にエラーが発生しました: $e');
      rethrow;
    }
  }
}
