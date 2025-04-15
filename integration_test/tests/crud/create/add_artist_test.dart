import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';

import '../../../utils/robots/auth_robot.dart';
import '../../../utils/robots/form_robot.dart';
import '../../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('アーティスト登録', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('アーティスト登録', (WidgetTester tester) async {
      final authRobot = AuthRobot(tester, container);
      await authRobot.initializeAndLogin();

      final naviRobot = NavigationRobot(tester);
      await naviRobot.waitForWidget(IdolGroupListScreen);
      await naviRobot.toAddArtist();

      final name = 'test-artist';
      final comment = 'test-comment';
      final formRobot = FormRobot(tester, container);
      await formRobot.enterName(name);
      await formRobot.enterComment(comment);
      await formRobot.tapSubmitButton();

      await formRobot.waitForWidget(IdolGroupListScreen);
      formRobot.expectSuccessMessage(dataType: 'アーティスト', name: name);

      await formRobot.deleteTestData(table: TableName.artists, name: name);
    });

    testWidgets('アーティストヴァリデーション', (WidgetTester tester) async {
      final authRobot = AuthRobot(tester, container);
      await authRobot.initializeAndLogin();

      final naviRobot = NavigationRobot(tester);
      await naviRobot.waitForWidget(IdolGroupListScreen);
      await naviRobot.toAddArtist();

      final formRobot = FormRobot(tester, container);

      await formRobot.tapSubmitButton();
      formRobot.expectValidationMessage();
    });
  });
}
