import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_provider.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mocks/logger.mocks.dart';

class TestUtils {
  static bool _isInitialized = false;

  static Future<ProviderContainer> setupTestContainer() async {
    SharedPreferences.setMockInitialValues({});

    if (!_isInitialized) {
      await Supabase.initialize(
        url: 'https://mock.supabase.co',
        anonKey: 'fakeAnonKey',
        httpClient: MockSupabaseHttpClient(),
      );
      _isInitialized = true;
    }

    final mockSupabase = Supabase.instance.client;
    logger = MockLogger();

    return ProviderContainer(
      overrides: [
        supabaseProvider.overrideWithValue(mockSupabase),
      ],
    );
  }

  static Future<void> cleanup() async {
    if (_isInitialized) {
      await Supabase.instance.dispose();
      _isInitialized = false;
    }
  }
}
