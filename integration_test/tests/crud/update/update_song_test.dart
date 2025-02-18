import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/posts/add_song.dart';

import '../../../utils/robots/auth_robot.dart';
import '../../../utils/robots/form_robot.dart';
import '../../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('曲を編集する', (WidgetTester tester) async {
    // ログイン
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    // 編集ページへ画面遷移
    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);
    await naviRobot.toEditSong();
    await naviRobot.expectWidget(AddSongScreen);

    // 編集しホームに戻る
    final editComment = 'edit-comment';
    final formRobot = FormRobot(tester);
    await formRobot.enterComment(editComment);
    await formRobot.tapSubmitButton();
    await formRobot.expectWidget(IdolGroupListScreen);
  });
}
