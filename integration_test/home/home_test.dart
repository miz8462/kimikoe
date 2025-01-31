import 'package:flutter_test/flutter_test.dart';

import '../robots/auth_robot.dart';
import '../robots/home_robot.dart';

void main() {
  testWidgets('RefreshIndicatorテスト', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final robot = HomeRobot(tester);

    await robot.expectHomeScreen();

    await robot.refreshScreen();

    await robot.expectHomeScreen();
  });
}
