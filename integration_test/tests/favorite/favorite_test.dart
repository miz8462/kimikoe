import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/group_detail/group_detail.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/lyric/song.dart';

import '../../utils/robots/auth_robot.dart';
import '../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('グループのスターをタップしたらお気に入りグループに追加される', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);

    await naviRobot.toGroupDetail();
    await naviRobot.expectWidget(GroupDetailScreen);

    await naviRobot.tapStar();
    await naviRobot.expectIconOnWidget(icon: Icons.star, widget: TopBar);
    await naviRobot.tapStar();
    await naviRobot.expectIconOnWidget(icon: Icons.star_border, widget: TopBar);
  });

  testWidgets('曲のスターをタップしたらお気に入り曲に追加される', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);

    await naviRobot.toSongInfo();
    await naviRobot.expectWidget(SongScreen);

    await naviRobot.tapStar();
    await naviRobot.expectIconOnWidget(icon: Icons.star, widget: TopBar);
    await naviRobot.tapStar();
    await naviRobot.expectIconOnWidget(icon: Icons.star_border, widget: TopBar);
  });
}
