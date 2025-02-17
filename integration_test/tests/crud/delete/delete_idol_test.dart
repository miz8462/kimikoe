import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';

import '../../../utils/robots/auth_robot.dart';
import '../../../utils/robots/form_robot.dart';
import '../../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('アイドル削除', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toAddIdol();

    final name = 'test-idol';
    final formRobot = FormRobot(tester);
    await formRobot.enterName(name);
    await formRobot.selectGroup(groupName: 'test-group-sapporo');
    await formRobot.tapSubmitButton();

    await formRobot.waitForWidget(IdolGroupListScreen);
    formRobot.expectSuccessMessage(dataType: 'アイドル', name: name);

    // 削除
    await naviRobot.toIdolDetail();
    await naviRobot.tapTopBarMenu();
    await naviRobot.tapDeleteMenu();
    await naviRobot.tapDeleteYes();
    await naviRobot.expectWidget(IdolGroupListScreen);
  });
}
