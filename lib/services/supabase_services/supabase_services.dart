import 'package:kimikoe_app/services/supabase_services/delete.dart';
import 'package:kimikoe_app/services/supabase_services/favorite.dart';
import 'package:kimikoe_app/services/supabase_services/fetch.dart';
import 'package:kimikoe_app/services/supabase_services/insert.dart';
import 'package:kimikoe_app/services/supabase_services/search.dart';
import 'package:kimikoe_app/services/supabase_services/storage.dart';
import 'package:kimikoe_app/services/supabase_services/update.dart';
import 'package:kimikoe_app/services/supabase_services/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  SupabaseServices(this.client) {
    _initializeServices();
  }

  final SupabaseClient client;
  late final Delete delete;
  late final Favorite favorite;
  late final Fetch fetch;
  late final Insert insert;
  late final Search search;
  late final Storage storage;
  late final Update update;
  late final Utils utils;

  void _initializeServices() {
    delete = Delete(client);
    favorite = Favorite(client);
    fetch = Fetch(client);
    insert = Insert(client);
    search = Search(client);
    storage = Storage(client);
    update = Update(client);
    utils = Utils(fetch: fetch, storage: storage);
  }
}
