import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/main.dart' as app;
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'robots/auth_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  testWidgets('ログイン', (WidgetTester tester) async {
    await app.main();
    await Supabase.instance.client.auth.signOut();

    await tester.pumpAndSettle();

    expect(find.byType(KimikoeApp), findsOneWidget);
    expect(find.byType(SignInScreen), findsOneWidget);

    final email = 'doskoi@doskoi.com';
    final password = 'doskoidoskoi';

    final robot = AuthRobot(tester);

    await tester.pumpAndSettle();

    await robot.enterEmail(email);
    await robot.enterPassword(password);
    await robot.tapLoginButton();
    logger.d('ログインボタンタップ完了');

    await tester.pumpAndSettle();
    logger.d('画面遷移完了');
    await robot.expectHomeScreen();
    logger.d('ホーム画面表示完了');
  });
  // testWidgets('サインアップ', (WidgetTester tester) async {});
  // testWidgets('Googleサインイン', (WidgetTester tester) async {});
}
