// READ
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> fetchArtists({
  required SupabaseClient supabase,
  required Logger logger,
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
  required Logger logger,
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

// HACK: Supabase CLI でできるらしいよ
String fetchImageUrl(
  String imagePath, {
  required Logger logger,
  SupabaseClient? injectedSupabase,
}) {
  // XXX: ｲｼﾞﾙﾅｷｹﾝ
  final diSupabase = injectedSupabase ?? supabase;
  if (imagePath == noImage) return noImage;
  try {
    final url =
        diSupabase.storage.from(TableName.images).getPublicUrl(imagePath);
    logger.i('画像URLを取得しました');
    return url;
  } catch (e) {
    logger.e('画像URLの取得中にエラーが発生しました', error: e);
    return noImage;
  }
}

Future<List<Map<String, dynamic>>> fetchIdAndNameList(
  String tableName, {
  required SupabaseClient supabase,
  required Logger logger,
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

Future<List<Artist>> fetchArtistList({
  required SupabaseClient supabase,
  required Logger logger,
}) async {
  try {
    logger.i('Supabaseからアーティストデータを取得中...');
    final response = await fetchArtists(supabase: supabase, logger: logger);
    logger.i('${response.length}件のアーティストデータをSupabaseから取得しました');
    final artists = response.map<Artist>((artist) {
      final imageUrl = fetchImageUrl(
        artist[ColumnName.imageUrl],
        logger: logger,
        injectedSupabase: supabase,
      );
      return Artist(
        id: artist[ColumnName.id],
        name: artist[ColumnName.name],
        imageUrl: imageUrl,
        comment: artist[ColumnName.comment],
      );
    }).toList();
    logger.i('${artists.length}件のアーティストデータをリストにしました');
    return artists;
  } catch (e, stackTrace) {
    logger.e(
      'アーティストリストの取得またはマッピング中にエラーが発生しました',
      error: e,
      stackTrace: stackTrace,
    );
    return [];
  }
}

int fetchSelectedDataIdFromName({
  required List<Map<String, dynamic>> list,
  required String name,
}) {
  final selectedDataList =
      list.where((item) => item[ColumnName.name] == name).toList();
  if (selectedDataList.isEmpty) {
    logger.e('指定された名前: $name に対するデータが見つかりません');
    throw StateError('指定された名前: $name に対するデータが見つかりません');
  }
  final selectedData = selectedDataList.single;
  final selectedDataId = selectedData[ColumnName.id] as int;
  logger.i('指定された名前: $name に対するデータIDを取得しました');
  return selectedDataId;
}

Stream<dynamic> fetchDataByStream({
  required String table,
  required String id,
  required SupabaseClient supabase,
  required Logger logger,
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
