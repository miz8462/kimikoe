import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';

final fetchGroupMembersProvider = Provider<
    Future<List<Map<String, dynamic>>> Function(
      int groupId,
    )>((ref) {
  final supabaseServices = ref.watch(supabaseServicesProvider);
  return supabaseServices.fetch.fetchGroupMembers;
});
