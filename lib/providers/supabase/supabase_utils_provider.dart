import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_utils.dart';

final supabaseUtilsProvider = Provider<SupabaseUtils>((ref) {
  final supabaseServices = ref.watch(supabaseServicesProvider);
  return SupabaseUtils(
    fetch: supabaseServices.fetch,
    storage: supabaseServices.storage,
  );
});
