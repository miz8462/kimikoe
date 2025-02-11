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

  testWidgets('グループ登録', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForScreen(IdolGroupListScreen);
    await naviRobot.toAddGroup();

    final name = 'test-group';
    final comment = 'test-comment';
    final formRobot = FormRobot(tester);
    await formRobot.enterName(name);
    await formRobot.enterComment(comment);
    await formRobot.ensureSubmitButton();
    await formRobot.tapSubmitButton();

    await formRobot.waitForScreen(IdolGroupListScreen);
    formRobot.expectSuccessMessage(dataType: 'グループ', name: name);

    await formRobot.deleteTestData(table: TableName.idolGroups, name: name);
  });

  testWidgets('グループヴァリデーション', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForScreen(IdolGroupListScreen);
    await naviRobot.toAddGroup();

    final formRobot = FormRobot(tester);

    await formRobot.ensureSubmitButton();
    await formRobot.tapSubmitButton();
    await formRobot.ensureVisibleWidget(WidgetKeys.name);
    formRobot.expectValidationMessage('グループ');
  });
}
