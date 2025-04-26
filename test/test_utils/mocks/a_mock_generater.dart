import 'package:kimikoe_app/services/supabase_services/fetch.dart';
import 'package:kimikoe_app/services/supabase_services/storage.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  SupabaseServices,
  Fetch,
  Storage,
])
void main() {}
