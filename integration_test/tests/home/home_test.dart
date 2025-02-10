import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';

import '../../utils/robots/auth_robot.dart';
import '../../utils/robots/home_robot.dart';

void main() {
  testWidgets('RefreshIndicatorテスト', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final robot = HomeRobot(tester);

    await robot.expectScreen(IdolGroupListScreen);

    await robot.refreshScreen();

    await robot.expectScreen(IdolGroupListScreen);
  });
}
