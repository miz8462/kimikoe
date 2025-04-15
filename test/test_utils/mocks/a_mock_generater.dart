import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_storage.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  SupabaseServices,
  SupabaseFetch,
  SupabaseStorage,
])
void main() {}
