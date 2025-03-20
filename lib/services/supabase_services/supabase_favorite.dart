import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';

Future<void> addFavoriteGroup({
  required String userId,
  required int groupId,
  required String table,
}) async {
  try {
    await supabase.from(table).insert({
      ColumnName.userId: userId,
      ColumnName.groupId: groupId,
    });
  } catch (e) {
    logger.e('グループをお気に入りに追加中にエラーが発生しました: $e');
    rethrow;
  }
}

Future<void> removeFavoriteGroup({
  required String userId,
  required int groupId,
  required String table,
}) async {
  try {
    await supabase
        .from(table)
        .delete()
        .eq(
          ColumnName.userId,
          userId,
        )
        .eq(
          ColumnName.groupId,
          groupId,
        );
  } catch (e) {
    logger.e('グループをお気に入りに削除にエラーが発生しました: $e');
    rethrow;
  }
}
