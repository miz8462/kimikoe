import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/supabase/supabase_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';

final supabaseServicesProvider = Provider<SupabaseServices>((ref) {
  final client = ref.watch(supabaseProvider);
  return SupabaseServices(client);
});
