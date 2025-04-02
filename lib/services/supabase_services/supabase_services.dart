import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_favorite.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_insert.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_storage.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_update.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_utils.dart';

class SupabaseServices {
  static final SupabaseDelete delete = SupabaseDelete();
  static final SupabaseFavorite favorite = SupabaseFavorite();
  static final SupabaseFetch fetch = SupabaseFetch();
  static final SupabaseInsert insert = SupabaseInsert();
  static final SupabaseStorage storage = SupabaseStorage();
  static final SupabaseUpdate update = SupabaseUpdate();
  static final SupabaseUtils utils = SupabaseUtils();
}
