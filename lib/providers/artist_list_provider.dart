import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/services/supabase_service.dart';
import 'package:kimikoe_app/utils/logging_util.dart';
import 'package:logger/logger.dart';

class ArtistListNotifier extends StateNotifier<List<Artist>> {
  ArtistListNotifier(
    super.state, {
    required this.logger,
  });
  final Logger logger;

  Artist? getArtistById(int? id) {
    if (id == null) {
      logger.w('アーティストのIDがNULLです');
      return null;
    }
    try {
      return state.firstWhere(
        (artist) => artist.id == id,
        orElse: () {
          final message = 'IDが $id のアーティストが見つかりませんでした';
          logger.e(message);
          throw StateError(message);
        },
      );
    } catch (e) {
      logger.e('ID:$id のアーティストを見つける際にエラーが発生しました', error: e);
      if (e is StateError) rethrow;
      return null;
    }
  }
}

final artistListProvider =
    StateNotifierProvider<ArtistListNotifier, List<Artist>>((ref) {
  final asyncValue = ref.watch(artistListFromSupabaseProvider);
  logAsyncValue(asyncValue, logger);

  return asyncValue.maybeWhen(
    data: (artists) => ArtistListNotifier(artists, logger: logger),
    orElse: () {
      logger.w('データが見つからないため、空のアーティストリストを返します');
      return ArtistListNotifier([], logger: logger);
    },
  );
});

final artistListFromSupabaseProvider =
    FutureProvider<List<Artist>>((ref) async {
  final logger = ref.read(loggerProvider);
  final supabase = ref.read(supabaseProvider);
  try {
    logger.i('Supabaseからアーティストデータを取得中...');
    final response =
        await fetchArtists(supabase: supabase, injectedlogger: logger);
    logger.i('${response.length}件のアーティストデータをSupabaseから取得しました');
    final artists = response.map<Artist>((artist) {
      final imageUrl = fetchImageUrl(
        artist[ColumnName.imageUrl],supabaseClient: supabase,
        injectedlogger: logger,
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
});
