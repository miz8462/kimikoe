import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/screens/posts/add_idol.dart';

import 'custom_robot.dart';

class NavigationRobot extends CustomBaseRobot {
  NavigationRobot(super.tester);

  Future<void> toSongList() async {
    await tapFirstInList('group');
  }

  Future<void> toSongInfo() async {
    await toSongList();
    await tapButton('song-card');
  }

  Future<void> toGroupDetail() async {
    await toSongList();
    await tapButton('group-card-m');
  }

  Future<void> toEditGroup() async {
    await toGroupDetail();
    await tapButton('top-bar-menu');
    await tapButton('edit');
  }

  Future<void> toIdolDetail() async {
    await toGroupDetail();
    await tapButton('member-0');
  }

  Future<void> toEditIdol() async {
    await toIdolDetail();
    await tapButton('top-bar-menu');
    await tapButton('edit');
    await waitForScreen(AddIdolScreen);
  }

  Future<void> toAddSong() async {
    await tapButton('add-button');
    await tapButton('add-song');
  }

  Future<void> toAddGroup() async {
    await tapButton('add-button');
    await tapButton('add-group');
  }

  Future<void> toAddIdol() async {
    await tapButton('add-button');
    await tapButton('add-idol');
  }

  Future<void> toAddArtist() async {
    await tapButton('add-button');
    await tapButton('add-artist');
  }

  Future<void> toUserInfo() async {
    await tapButton('user-avatar');
  }

  Future<void> toEditUser() async {
    await toUserInfo();
    await tapButton('top-bar-menu');
    await tapButton('edit');
  }
}
