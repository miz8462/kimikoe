import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return supabase;
});
late SupabaseClient supabase;
void initializeSupabaseClient() {
  supabase = Supabase.instance.client;
} 
