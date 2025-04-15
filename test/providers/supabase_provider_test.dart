import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/supabase/supabase_provider.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    expect(supabase, equals(mockSupabase));
    expect(supabase, same(mockSupabase));
  });
  test('supabaseがちゃんと初期化されてる', () async {
    SharedPreferences.setMockInitialValues({});
    // Supabaseの初期化
    await Supabase.initialize(
      url: 'https://mock.supabase.co',
      anonKey: 'fakeAnonKey',
    );
    final supabase = Supabase.instance.client;
    final container = createContainer(
      overrides: [
        supabaseProvider.overrideWithValue(supabase),
      ],
    ); // Supabaseインスタンスチェック
    final client = container.read(supabaseProvider);
    expect(client, isA<SupabaseClient>());
    expect(client, same(supabase));
  });
}
