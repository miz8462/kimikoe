import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kimikoe_app/screens/group_detail/group_detail.dart';
import 'package:kimikoe_app/screens/idol_detail.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/lyric/song.dart';
import 'package:kimikoe_app/screens/posts/add_artist.dart';
import 'package:kimikoe_app/screens/posts/add_group.dart';
import 'package:kimikoe_app/screens/posts/add_idol.dart';
import 'package:kimikoe_app/screens/posts/add_song.dart';
import 'package:kimikoe_app/screens/posts/edit_user.dart';
import 'package:kimikoe_app/screens/song_list.dart';
import 'package:kimikoe_app/screens/user.dart';

import '../../utils/robots/auth_robot.dart';
import '../../utils/robots/navigation_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('各種ページへ遷移する', (WidgetTester tester) async {
    final authRobot = AuthRobot(tester, container);
    await authRobot.initializeAndLogin();

    final naviRobot = NavigationRobot(tester);
    await naviRobot.waitForWidget(IdolGroupListScreen);

    // グループ、アイドル、歌詞系
    await naviRobot.toSongList();
    await naviRobot.expectWidget(SongListScreen);
    await naviRobot.tapHomeButon();
    await naviRobot.toGroupDetail();
    await naviRobot.expectWidget(GroupDetailScreen);
    await naviRobot.tapHomeButon();
    await naviRobot.toIdolDetail();
    await naviRobot.expectWidget(IdolDetailScreen);
    await naviRobot.tapHomeButon();
    await naviRobot.toSongInfo();
    await naviRobot.expectWidget(SongScreen);
    await naviRobot.tapHomeButon();

    // TODO: お気に入り系

    // 編集系
    await naviRobot.toEditGroup();
    await naviRobot.expectWidget(AddGroupScreen);
    await naviRobot.tapHomeButon();
    await naviRobot.toEditIdol();
    await naviRobot.expectWidget(AddIdolScreen);

    // データ登録系
    await naviRobot.toAddSong();
    await naviRobot.expectWidget(AddSongScreen);
    await naviRobot.toAddGroup();
    await naviRobot.expectWidget(AddGroupScreen);
    await naviRobot.toAddIdol();
    await naviRobot.expectWidget(AddIdolScreen);
    await naviRobot.toAddArtist();
    await naviRobot.expectWidget(AddArtistScreen);

    // ユーザー系
    await naviRobot.toUserInfo();
    await naviRobot.expectWidget(UserScreen);
    await naviRobot.tapMenuAndEdit();
    await naviRobot.expectWidget(EditUserScreen);
  });
}
