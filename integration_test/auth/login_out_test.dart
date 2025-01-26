import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../integration_test_utils/auth_utils.dart';
import '../robots/auth_robot.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ログイン', (WidgetTester tester) async {
    await login(tester);

    final robot = AuthRobot(tester);

    await robot.expectHomeScreen();

    await robot.tapLogoutButton();
    // await tester.pump(Duration(seconds: 1));
    
    // await robot.expectSignInScreen();
  });
}
