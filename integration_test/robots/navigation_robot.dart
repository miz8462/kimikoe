import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/screens/song_list.dart';

import 'custom_robot.dart';

class NavigationRobot extends CustomRobot {
  NavigationRobot(super.tester);

  Future<void> toSongList() async {
    await tapFirstInList('group');
    await expectScreen(SongListScreen);
  }

  Future<void> toGroupDetail() async {}
  Future<void> toEditGroup() async {}
  Future<void> toIdolDetail() async {}
  Future<void> toEditIdol() async {}
  Future<void> toAddSong() async {}
  Future<void> toAddGroup() async {}
  Future<void> toAddIdol() async {}
  Future<void> toAddArtist() async {}
  Future<void> toUser() async {}
  Future<void> toEditUser() async {}
}
