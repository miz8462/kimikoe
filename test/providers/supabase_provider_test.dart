import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test_utils/test_helpers.dart';

void main() {
  test('supabaseProvider', () {
    final mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: MockSupabaseHttpClient(),
    );
    final container = createContainer(
      overrides: [supabaseProvider.overrideWithValue(mockSupabase)],
    );

    // Supabaseインスタンスチェック
    final supabase = container.read(supabaseProvider);
    expect(supabase, isA<SupabaseClient>());
     // mockSupabaseとでオーバーライドされているか、同じインスタンスか確認
    expect(supabase, same(mockSupabase));
  });
}
