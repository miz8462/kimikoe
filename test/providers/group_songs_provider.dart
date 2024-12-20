import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test_utils/mocks/logger_mock.dart';

void main() {
  late SupabaseClient mockSupabase;
  late MockLogger mockLogger;

  setUpAll(() {
    mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: MockSupabaseHttpClient(),
    );
    mockLogger = MockLogger();
  });

  group('groupSongsProvider', () {
    
  });
}
