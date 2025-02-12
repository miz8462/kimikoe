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
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toAddGroup();

    final name = 'test-group';
    final official = 'https://example.com';
    final twitter = 'https://twitter.com/test';
    final instagram = 'https://instagram.com/test';
    final schedule = 'https://example.com/schedule';
    final comment = 'test-comment';
    final formRobot = FormRobot(tester);
    await formRobot.enterName(name);
    await formRobot.selectImage();
    await formRobot.selectYear();
    await formRobot.enterOfficial(official);
    await formRobot.enterTwitter(twitter);
    await formRobot.enterInstagram(instagram);
    await formRobot.enterSchedule(schedule);
    await formRobot.enterComment(comment);
    await formRobot.ensureSubmitButton();
    await formRobot.tapSubmitButton();

    await formRobot.waitForWidget(IdolGroupListScreen);
    formRobot.expectSuccessMessage(dataType: 'グループ', name: name);

    await formRobot.deleteTestData(table: TableName.idolGroups, name: name);
  });

  testWidgets('グループヴァリデーション', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toAddGroup();

    final formRobot = FormRobot(tester);

    await formRobot.ensureSubmitButton();
    await formRobot.tapSubmitButton();
    await formRobot.ensureVisibleWidget(WidgetKeys.name);
    formRobot.expectValidationMessage('グループ');
  });
}
