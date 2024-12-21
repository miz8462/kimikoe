import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_utils.dart';
import 'package:kimikoe_app/utils/logging_util.dart';
import 'package:logger/logger.dart';

class ArtistsNotifier extends StateNotifier<List<Artist>> {
  ArtistsNotifier(
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

final artistsFromSupabaseProvider = FutureProvider<List<Artist>>((ref) async {
  // プロバイダーを作り、そこを通すことで
  // ProviderContainerでオーバーライドしたモックを受け取ることができる
  final supabase = ref.read(supabaseProvider);

  return createArtistList(supabase: supabase);
});

final artistsProvider =
    StateNotifierProvider<ArtistsNotifier, List<Artist>>((ref) {
  final logger = ref.read(loggerProvider);
  final asyncValue = ref.watch(artistsFromSupabaseProvider);

  logAsyncValue(asyncValue: asyncValue, logger: logger);

  return asyncValue.maybeWhen(
    data: (artists) => ArtistsNotifier(artists, logger: logger),
    orElse: () {
      logger.w('データが見つからないため、空のアーティストリストを返します');
      return ArtistsNotifier([], logger: logger);
    },
  );
});
