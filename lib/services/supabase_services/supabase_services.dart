import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_favorite.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_insert.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_storage.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_update.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_utils.dart';

class SupabaseServices {
  SupabaseServices()
      : delete = SupabaseDelete(),
        favorite = SupabaseFavorite(),
        fetch = SupabaseFetch(),
        insert = SupabaseInsert(),
        storage = SupabaseStorage(),
        update = SupabaseUpdate(),
        utils = SupabaseUtils();

  final SupabaseDelete delete;
  final SupabaseFavorite favorite;
  final SupabaseFetch fetch;
  final SupabaseInsert insert;
  final SupabaseStorage storage;
  final SupabaseUpdate update;
  final SupabaseUtils utils;
}
