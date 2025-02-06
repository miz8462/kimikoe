import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/posts/add_song.dart';

import '../robots/auth_robot.dart';
import '../robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('歌詞登録ページへ遷移', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForScreen(IdolGroupListScreen);
    await naviRobot.toAddSong();
    await naviRobot.expectScreen(AddSongScreen);
  });
}
