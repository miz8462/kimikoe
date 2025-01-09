import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/main.dart' as app;
import 'package:kimikoe_app/providers/supabase_provider.dart';

import '../robots/auth_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('サインアップ', (WidgetTester tester) async {
    await app.main();

    if (supabase.auth.currentSession != null) {
      await supabase.auth.signOut();
    }
    await tester.pumpAndSettle();

    final email = createRandomEmail();

    final password = 'doskoidoskoi';
    final name = 'doskoi';

    final robot = AuthRobot(tester);
    await tester.pumpAndSettle();

    await robot.tapToggleAuthButton();
    await tester.pumpAndSettle();

    // サインアップ
    await robot.enterEmail(email);
    await robot.enterPassword(password);
    await robot.enterName(name);
    await tester.pumpAndSettle();
    await robot.tapLoginOrSignUpButton();
    await tester.pumpAndSettle();

    // ホーム画面に遷移したことを確認
    await robot.expectHomeScreen();

    // テストデータ削除
    // await robot.deleteUser();
    // await robot. deleteUserAdmin();
  });
}

String createRandomEmail() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return 'testuser$timestamp@example.com';
}
