import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';

final supabaseServices = SupabaseServices();

final artistsFromSupabaseProvider = FutureProvider<List<Artist>>((ref) async {
  // プロバイダーを作り、そこを通すことで
  // ProviderContainerでオーバーライドしたモックを受け取ることができる
  final supabase = ref.read(supabaseProvider);

  return supabaseServices.utils.createArtistList(supabase: supabase);
});

final artistsListProvider = Provider<List<Artist>>((ref) {
  final asyncValue = ref.watch(artistsFromSupabaseProvider);
  return asyncValue.when(
    data: (artists) => artists,
    error: (_, __) => [],
    loading: () => [],
  );
});

// アーティスト検索用のプロバイダー
final artistByIdProvider = Provider.family<Artist?, int>((ref, id) {
  final artists = ref.watch(artistsListProvider);
  try {
    return artists.firstWhere(
      (artist) => artist.id == id,
    );
  } catch (e) {
    logger.e('ID:$id のアーティストを見つける際にエラーが発生しました', error: e);
    return null;
  }
});
