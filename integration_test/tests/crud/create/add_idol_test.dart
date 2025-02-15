import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';

import '../../../utils/robots/auth_robot.dart';
import '../../../utils/robots/form_robot.dart';
import '../../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('アイドル登録', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toAddIdol();

    final name = 'test-idol';
    final hometown = 'Sapporo';
    final comment = 'test-comment';
    final formRobot = FormRobot(tester);
    await formRobot.enterName(name);
    await formRobot.selectGroup();
    await formRobot.pickColor();
    await formRobot.selectImage();
    await formRobot.pickNumber('2003', WidgetKeys.birthYear);
    await formRobot.pickDate('09/15', WidgetKeys.birthday);
    await formRobot.pickNumber('163', WidgetKeys.height);
    await formRobot.enterHometown(hometown);
    await formRobot.pickNumber('2023', WidgetKeys.debutYear);
    await formRobot.enterComment(comment);
    await formRobot.tapSubmitButton();

    await formRobot.waitForWidget(IdolGroupListScreen);
    formRobot.expectSuccessMessage(dataType: 'アイドル', name: name);

    await formRobot.deleteTestData(table: TableName.idols, name: name);
  });

  testWidgets('アイドルヴァリデーション', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toAddIdol();

    final formRobot = FormRobot(tester);

    await formRobot.tapSubmitButton();
    await formRobot.ensureVisibleWidget(WidgetKeys.name);
    formRobot.expectValidationMessage();
  });
}
