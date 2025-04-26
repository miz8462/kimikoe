import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Search {
  Search(this.client);
  final SupabaseClient client;

  Future<List<Map<String, dynamic>>> group(String query) async {
    try {
      return await client
          .from(TableName.groups)
          .select(
            '${ColumnName.id}, ${ColumnName.name}, ${ColumnName.imageUrl}',
          )
          .ilike(ColumnName.name, '%$query%');
    } catch (e) {
      logger.e('グループ検索中にエラーが発生しました', error: e);
      return [];
    }
  }

  // 曲名で検索
  Future<List<Map<String, dynamic>>> song(String query) async {
    try {
      final response = await client
          .from(TableName.songs)
          .select(
            '${ColumnName.id}, '
            '${ColumnName.title}, '
            '${ColumnName.lyrics}, '
            'groups!inner(name)',
          )
          .ilike(ColumnName.title, '%$query%');
      return response;
    } catch (e) {
      logger.d('曲名検索中にエラーが発生しました', error: e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> idol(String keyword) async {
    try {
      final response = await client
          .from(TableName.idols)
          .select('${ColumnName.id}, ${ColumnName.name}')
          .ilike(ColumnName.name, '%$keyword%');
      return response;
    } catch (e) {
      logger.d('アイドル検索中にエラーが発生しました', error: e);
      return [];
    }
  }

  // 検索の統合
  Future<Map<String, List<Map<String, dynamic>>>> searchAll(
    String query,
  ) async {
    try {
      // グループ検索
      final groupResponse = await group(query);
      // 曲名検索
      final songResponse = await song(query);
      final idolResponse = await idol(query);

      return {
        'groups': groupResponse,
        'songs': songResponse,
        'idols': idolResponse,
      };
    } catch (e) {
      logger.d('統合検索中にエラーが発生しました', error: e);
      return {'groups': [], 'songs': [], 'idols': []};
    }
  }
}
