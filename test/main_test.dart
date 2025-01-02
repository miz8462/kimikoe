import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'test_utils/mocks/go_true_client_mock.dart';
import 'test_utils/mocks/logger_mock.dart';
import 'test_utils/mocks/supabase_client_mock.dart';
import 'test_utils/test_helpers.dart';

void main() async {
  final mockLogger = MockLogger();
  await testSupabaseSetUpAll(mockLogger);

  testWidgets('アプリが正常に起動する', (WidgetTester tester) async {
    final mockSupabaseClient = MockSupabaseClient();
    final mockAuth = MockGoTrueClient();
    when(mockSupabaseClient.auth).thenReturn(mockAuth);

    // 初期化テスト
    expect(logger, isNotNull);
    expect(dotenv.env['LOCAL_SUPABASE_URL'], isNotNull);
    expect(dotenv.env['LOCAL_SUPABASE_ANON_KEY'], isNotNull);
    expect(Supabase.instance.client, isNotNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supabaseProvider.overrideWithValue(mockSupabaseClient),
          loggerProvider.overrideWithValue(mockLogger),
        ],
        child: const KimikoeApp(),
      ),
    );

    expect(find.byType(KimikoeApp), findsOneWidget);
  });
}
