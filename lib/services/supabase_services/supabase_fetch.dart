import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFetch {
  Future<List<Map<String, dynamic>>> fetchArtists({
    required SupabaseClient supabase,
  }) async {
    try {
      final response = await supabase.from(TableName.artists).select();
      logger.i('アーティストのリストを取得しました');
      return response;
    } catch (e) {
      logger.e('アーティストのリストの取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchGroupMembers(
    int groupId, {
    required SupabaseClient supabase,
  }) async {
    try {
      final response = await supabase
          .from(TableName.idols)
          .select()
          .eq(ColumnName.groupId, groupId);
      logger.i('グループメンバーリストを取得しました');
      return response;
    } catch (e) {
      logger.e('グループメンバーリストの取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchIdAndNameList(
    String tableName, {
    required SupabaseClient supabase,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('${ColumnName.id}, ${ColumnName.name}');
      logger.i('$tableNameのIDと名前のリストを取得しました');
      return response;
    } catch (e) {
      logger.e('$tableNameのIDと名前のリストの取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  Stream<dynamic> fetchDataByStream({
    required String table,
    required String id,
    required SupabaseClient supabase,
  }) async* {
    try {
      final stream = supabase.from(table).stream(primaryKey: [id]);
      logger.i('$tableのデータをストリームで取得中...');
      await for (final data in stream) {
        yield data;
      }
    } catch (e) {
      logger.e('$tableのデータをストリームで取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }
}
