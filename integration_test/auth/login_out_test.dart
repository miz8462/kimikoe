import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/main.dart' as app;
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/screens/sign_in.dart';

import '../integration_test_utils/wait_for_condition.dart';
import '../robots/auth_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ログインテスト', () {
    testWidgets('ログイン成功', (WidgetTester tester) async {
      final robot = AuthRobot(tester);

      await robot.initializeAndLogin();

      await robot.expectHomeScreen();

      await robot.tapLogoutButton();

      await robot.expectSignInScreen();
    });

    testWidgets('ログイン失敗', (WidgetTester tester) async {
      await app.main();
      if (supabase.auth.currentSession != null) {
        await supabase.auth.signOut();
      }

      await waitForCondition(tester, find.byType(SignInScreen));

      final emailWithoutAtMark = 'wrong-address';
      final robot = AuthRobot(tester);

      await robot.enterEmail(emailWithoutAtMark);
      await robot.tapLoginButton();

      robot.expectEmailErrorMessage();
      robot.expectPasswordErrorMessage();
    });
  });
}
