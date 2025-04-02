import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUtils {
  Future<List<Artist>> createArtistList({
    required SupabaseClient supabase,
  }) async {
    try {
      logger.i('Supabaseからアーティストデータを取得中...');
      final response = await SupabaseServices.fetch.fetchArtists(
        supabase: supabase,
      );
      logger.i('${response.length}件のアーティストデータをSupabaseから取得しました');
      final artists = response.map<Artist>((artist) {
        final imageUrl = SupabaseServices.storage.fetchImageUrl(
          artist[ColumnName.imageUrl],
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

  int? findDataIdByName({
    required List<Map<String, dynamic>> list,
    required String name,
  }) {
    if (name.isEmpty) {
      logger.w('空の名前が指定されました');
      return null;
    }

    final selectedDataList =
        list.where((item) => item[ColumnName.name] == name).toList();
    if (selectedDataList.isEmpty) {
      logger.e('指定された名前: $name に対するデータが見つかりません');
      return null;
    }

    final selectedData = selectedDataList.single;
    final selectedDataId = selectedData[ColumnName.id] as int;
    logger.i('指定された名前: $name に対するデータIDを取得しました');
    return selectedDataId;
  }
}
