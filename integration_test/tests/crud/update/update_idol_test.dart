import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/posts/add_idol.dart';

import '../../../utils/robots/auth_robot.dart';
import '../../../utils/robots/form_robot.dart';
import '../../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('アイドルを編集する', (WidgetTester tester) async {
    // ログイン
    final authRobot = AuthRobot(tester, container);
    await authRobot.initializeAndLogin();

    // 編集ページへ画面遷移
    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toEditIdol();
    await naviRobot.expectWidget(AddIdolScreen);

    // 編集しホームに戻る
    final formRobot = FormRobot(tester, container);
    await formRobot.enterComment('edit-comment');
    await formRobot.tapSubmitButton();
    await formRobot.expectWidget(IdolGroupListScreen);
  });
}
