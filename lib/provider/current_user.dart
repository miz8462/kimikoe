import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';

final userDataProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final currentUserId = supabase.auth.currentUser!.id;
  final userData =
      await supabase.from('profiles').select().eq('id', currentUserId);
  return userData;
});
