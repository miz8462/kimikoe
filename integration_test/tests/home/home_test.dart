import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';

import '../../utils/robots/auth_robot.dart';
import '../../utils/robots/home_robot.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('RefreshIndicatorテスト', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester, container);
    await authRobot.initializeAndLogin();

    final robot = HomeRobot(tester);

    await robot.expectWidget(IdolGroupListScreen);

    await robot.refreshScreen();

    await robot.expectWidget(IdolGroupListScreen);
  });
}
