import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/main.dart' as app;
import 'package:kimikoe_app/providers/supabase_provider.dart';

import '../integration_test_utils/auth_utils.dart';
import '../robots/auth_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ログイン成功', (WidgetTester tester) async {
    await login(tester);

    final robot = AuthRobot(tester);

    await robot.expectHomeScreen();

    await robot.tapLogoutButton();
    await tester.pump(Duration(seconds: 2));

    await robot.expectSignInScreen();
  });

  testWidgets('ログイン失敗', (WidgetTester tester) async {
    await app.main();

    if (supabase.auth.currentSession != null) {
      await supabase.auth.signOut();
    }

    await tester.pumpAndSettle();

    final emailWithoutAtMark = 'wrong-address';

    final robot = AuthRobot(tester);

    await tester.pumpAndSettle();

    await robot.enterEmail(emailWithoutAtMark);
    await robot.tapLoginOrSignUpButton();

    await robot.expectEmailErrorMessage();
    await robot.expectPasswordErrorMessage();
  });
}
