import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/main.dart' as app;
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/sign_in.dart';

import '../../utils/robots/auth_robot.dart';
import '../../utils/robots/navigation_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ログイン、ログアウトテスト', () {
    testWidgets('ログイン、ログアウト成功', (WidgetTester tester) async {
      final robot = AuthRobot(tester);

      await robot.initializeAndLogin();

      await robot.expectWidget(IdolGroupListScreen);

      final naviRobot = NavigationRobot(tester);

      await naviRobot.toUserInfo();
      await naviRobot.tapMenuAndLogout();
      await robot.expectWidget(SignInScreen);
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
