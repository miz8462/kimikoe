import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/sign_in.dart';

import '../../utils/integration_test_utils/create_random_emal.dart';
import '../../utils/robots/auth_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('サインアップテスト', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('サインアップ成功', (WidgetTester tester) async {
      final email = createRandomEmail();
      final password = 'doskoidoskoi';
      final name = 'doskoi';

      final robot = AuthRobot(tester, container);
      await robot.launchApp();

      await robot.signUp(email, password, name);

      await robot.expectWidget(IdolGroupListScreen);

      // テストデータ削除
      await robot.deleteUser();
      await robot.deleteUserAdmin();
    });

    testWidgets('サインアップ失敗', (WidgetTester tester) async {
      final robot = AuthRobot(tester, container);
      await robot.launchApp();

      await robot.waitForWidget(SignInScreen);

      await robot.tapToggleAuthButton();

      // 何も入力せずにサインアップボタンをタップ
      await robot.tapLoginButton();

      robot.expectEmailErrorMessage();
      robot.expectPasswordLengthErrorMessage();
      robot.expectNameErrorMessage();
    });
  });
}
