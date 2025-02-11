import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';

import '../../../utils/robots/auth_robot.dart';
import '../../../utils/robots/form_robot.dart';
import '../../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('アーティスト登録', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForScreen(IdolGroupListScreen);
    await naviRobot.toAddArtist();

    final name = 'test-artist';
    final comment = 'test-comment';
    final formRobot = FormRobot(tester);
    await formRobot.enterName(name);
    await formRobot.enterComment(comment);
    await formRobot.ensureSubmitButton();
    await formRobot.tapSubmitButton();

    await formRobot.waitForScreen(IdolGroupListScreen);
    formRobot.expectAddArtistSuccessMessage();

    await formRobot.deleteTestArtist(name);
  });

  testWidgets('アーティストヴァリデーション', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForScreen(IdolGroupListScreen);
    await naviRobot.toAddArtist();

    final formRobot = FormRobot(tester);

    await formRobot.ensureSubmitButton();
    await formRobot.tapSubmitButton();
    formRobot.expectValidationMessage();
  });
}
