import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Fetch {
  Fetch(this.client);
  final SupabaseClient client;

  Future<Map<String, dynamic>> fetchIdol(int id) async {
    try {
      final response = await client
          .from(TableName.idols)
          .select()
          .eq(ColumnName.id, id)
          .single();
      logger.i('アイドルを取得しました');
      return response;
    } catch (e) {
      logger.e('アイドルの取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

    Future<Map<String, dynamic>> fetchSong(int id) async {
    try {
      final response = await client
          .from(TableName.songs)
          .select()
          .eq(ColumnName.id, id)
          .single();
      logger.i('曲を取得しました');
      return response;
    } catch (e) {
      logger.e('曲の取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchArtistsList() async {
    try {
      final response = await client.from(TableName.artists).select();
      logger.i('アーティストのリストを取得しました');
      return response;
    } catch (e) {
      logger.e('アーティストのリストの取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchSongsList(int groupId) async {
    try {
      final response = await client
          .from(TableName.songs)
          .select()
          .eq(ColumnName.groupId, groupId);
      logger.i('曲のリストを取得しました');
      return response;
    } catch (e) {
      logger.e('曲のリストの取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchGroupMembers(int groupId) async {
    try {
      final response = await client
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

  Future<Map<String, dynamic>> fetchCurrentUser(String currentUserId) async {
    try {
      final currentUser = await client
          .from(TableName.profiles)
          .select()
          .eq(ColumnName.id, currentUserId)
          .single();
      logger.i('現在のユーザーを取得しました');
      return currentUser;
    } catch (e) {
      logger.e('現在のユーザーの取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchIdAndNameList(
    String tableName,
  ) async {
    try {
      final response = await client
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
  }) async* {
    try {
      final stream = client.from(table).stream(primaryKey: [id]);
      logger.i('$tableのデータをストリームで取得中...');
      await for (final data in stream) {
        yield data;
      }
    } catch (e) {
      logger.e('$tableのデータをストリームで取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  // favorite
  Future<List<Map<String, dynamic>>> fetchFavorites({
    required String tableName,
    required String userId,
  }) async {
    try {
      final response =
          await client.from(tableName).select().eq(ColumnName.userId, userId);
      logger.i('お気に入りのグループを取得しました');
      return response;
    } catch (e) {
      logger.e('お気に入りのグループの取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchFavoriteGroups(
    List<int> favoriteIds,
  ) async {
    try {
      final response = await client
          .from(TableName.groups)
          .select()
          .inFilter(ColumnName.id, favoriteIds);
      logger.i('お気に入りのグループを取得しました');
      return response;
    } catch (e) {
      logger.e('お気に入りのグループの取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchFavoriteSongs(
    List<int> favoriteIds,
  ) async {
    try {
      final response = await client
          .from(TableName.songs)
          .select()
          .inFilter(ColumnName.id, favoriteIds);
      logger.i('お気に入りの曲を取得しました');
      return response;
    } catch (e) {
      logger.e('お気に入りの曲の取得中にエラーが発生しました', error: e);
      rethrow;
    }
  }
}
