import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/favorite/favorite.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/lyric/song.dart';

import '../../utils/robots/auth_robot.dart';
import '../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // testWidgets('グループのスターをタップするとお気に入りグループに追加あるいは削除される',
  //     (WidgetTester tester) async {
  //   final authRobot = AuthRobot(tester);
  //   await authRobot.initializeAndLogin();

  //   final naviRobot = NavigationRobot(tester);
  //   await naviRobot.waitForWidget(IdolGroupListScreen);

  //   // お気に入りグループページに何も登録されていないのを確認
  //   await naviRobot.tapFavoriteButton();
  //   await naviRobot.expectKey(Key(WidgetKeys.favoriteEmpty));

  //   // グループ詳細ページでお気に入り登録する
  //   await naviRobot.tapHomeButon();
  //   await naviRobot.toGroupDetail();
  //   await naviRobot.expectWidget(GroupDetailScreen);
  //   await naviRobot.tapStar();
  //   await naviRobot.expectIconOnWidget(icon: Icons.star, widget: TopBar);

  //   // お気に入りグループページにtest-group...が登録されているのを確認
  //   await naviRobot.tapHomeButon();
  //   await naviRobot.tapFavoriteButton();
  //   await naviRobot.expectKey(Key(WidgetKeys.testGroup));

  //   // グループ詳細ページでお気に入りを解除する
  //   await naviRobot.tapHomeButon();
  //   await naviRobot.toGroupDetail();
  //   await naviRobot.expectWidget(GroupDetailScreen);
  //   await naviRobot.tapStar();
  //   await naviRobot.expectIconOnWidget(icon: Icons.star_border, widget: TopBar);

  //   // お気に入りグループページに何も登録されていないのを確認
  //   await naviRobot.tapHomeButon();
  //   await naviRobot.tapFavoriteButton();
  //   await naviRobot.expectKey(Key(WidgetKeys.favoriteEmpty));
  // });

  testWidgets('曲のスターをタップしたらお気に入り曲に追加される', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);

    // お気に入り歌詞ページに何も登録されていないのを確認
    await naviRobot.tapFavoriteButton();
    await naviRobot.tapSongTab();
    await naviRobot.expectKey(Key(WidgetKeys.favoriteEmpty));

    // 曲詳細ページでお気に入り登録する
    await naviRobot.tapHomeButon();
    await naviRobot.toSongInfo();
    await naviRobot.expectWidget(SongScreen);
    await naviRobot.tapStar();
    await naviRobot.expectIconOnWidget(icon: Icons.star, widget: TopBar);

    // お気に入り曲ページにtest-song...が登録されているのを確認
    await naviRobot.tapHomeButon();
    await naviRobot.tapFavoriteButton();
    await naviRobot.tapSongTab();
    await naviRobot.expectKey(Key(WidgetKeys.testSong));

    // 曲詳細ページでお気に入りを解除する
    await naviRobot.tapHomeButon();
    await naviRobot.toSongInfo();
    await naviRobot.expectWidget(SongScreen);
    await naviRobot.tapStar();
    await naviRobot.expectIconOnWidget(icon: Icons.star_border, widget: TopBar);

    // お気に入り曲ページに何も登録されていないのを確認
    await naviRobot.tapHomeButon();
    await naviRobot.tapFavoriteButton();
    await naviRobot.tapSongTab();
    await naviRobot.expectKey(Key(WidgetKeys.favoriteEmpty));

    // お気に入りグループに遷移できるのを確認
    await naviRobot.tapGroupTab();
    await naviRobot.expectWidget(FavoriteScreen);
  });
}
