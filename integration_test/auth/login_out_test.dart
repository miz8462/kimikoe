import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/main.dart' as app;
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/sign_in.dart';

import '../robots/auth_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ログインテスト', () {
    testWidgets('ログイン成功', (WidgetTester tester) async {
      final robot = AuthRobot(tester);

      await robot.initializeAndLogin();

      await robot.expectScreen(IdolGroupListScreen);

      await robot.tapLogoutButton();

      await robot.expectScreen(SignInScreen);
    });

    testWidgets('ログイン失敗', (WidgetTester tester) async {
      await app.main();
      if (supabase.auth.currentSession != null) {
        await supabase.auth.signOut();
      }
      final robot = AuthRobot(tester);

      await robot.waitForCondition(find.byType(SignInScreen));

      final emailWithoutAtMark = 'wrong-address';

      await robot.enterEmail(emailWithoutAtMark);
      await robot.tapLoginButton();

      robot.expectEmailErrorMessage();
      robot.expectPasswordErrorMessage();
    });
  });
}
