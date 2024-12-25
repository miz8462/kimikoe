import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../test_utils/mocks/logger_mock.dart';

void main() {
  final mockLogger = MockLogger();
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    logger = mockLogger;
  });
  testWidgets('初期ルートがログイン画面', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(child: const KimikoeApp()));
    expect(find.byType(SignInScreen), findsOneWidget);
  });
}
