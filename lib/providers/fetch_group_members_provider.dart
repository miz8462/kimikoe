import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final fetchGroupMembersProvider = Provider<
    Future<List<Map<String, dynamic>>> Function(
      int groupId, {
      required SupabaseClient supabase,
    })>((ref) {
  return fetchGroupMembers;
});
