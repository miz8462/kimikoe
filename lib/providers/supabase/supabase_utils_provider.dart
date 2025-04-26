import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';
import 'package:kimikoe_app/services/supabase_services/utils.dart';

final supabaseUtilsProvider = Provider<Utils>((ref) {
  final supabaseServices = ref.watch(supabaseServicesProvider);
  return Utils(
    fetch: supabaseServices.fetch,
    storage: supabaseServices.storage,
  );
});
