import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_favorite.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_insert.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_storage.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_update.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  SupabaseServices(this.client) {
    _initializeServices();
  }

  final SupabaseClient client;
  late final SupabaseDelete delete;
  late final SupabaseFavorite favorite;
  late final SupabaseFetch fetch;
  late final SupabaseInsert insert;
  late final SupabaseStorage storage;
  late final SupabaseUpdate update;
  late final SupabaseUtils utils;

  void _initializeServices() {
    delete = SupabaseDelete(client);
    favorite = SupabaseFavorite(client);
    fetch = SupabaseFetch(client);
    insert = SupabaseInsert(client);
    storage = SupabaseStorage(client);
    update = SupabaseUpdate(client);
    utils = SupabaseUtils(fetch: fetch, storage: storage);
  }
}
