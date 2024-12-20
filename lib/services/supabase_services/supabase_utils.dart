import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_storage.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Artist>> createArtistList({
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

int findDataIdByName({
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
