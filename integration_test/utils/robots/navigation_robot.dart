import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/screens/posts/add_idol.dart';

import 'custom_robot.dart';

class NavigationRobot extends CustomRobot {
  NavigationRobot(super.tester);

  Future<void> tapAddButton() async {
    await tapButton(WidgetKeys.addButton);
  }

  Future<void> tapTopBarMenu() async {
    await tapButton(WidgetKeys.topBarMenu);
  }

  Future<void> tapEdit() async {
    await tapButton(WidgetKeys.edit);
  }

  Future<void> toSongList() async {
    await tapFirstInList(WidgetKeys.group);
  }

  Future<void> toSongInfo() async {
    await toSongList();
    await tapButton(WidgetKeys.songCard);
  }

  Future<void> toGroupDetail() async {
    await toSongList();
    await tapButton(WidgetKeys.groupCardM);
  }

  Future<void> toEditGroup() async {
    await toGroupDetail();
    await tapTopBarMenu();
    await tapEdit();
  }

  Future<void> toIdolDetail() async {
    await toGroupDetail();
    await tapButton(WidgetKeys.member);
  }

  Future<void> toEditIdol() async {
    await toIdolDetail();
    await tapTopBarMenu();
    await tapEdit();
    await waitForScreen(AddIdolScreen);
  }

  Future<void> toAddSong() async {
    await tapAddButton();
    await tapButton(WidgetKeys.addSong);
  }

  Future<void> toAddGroup() async {
    await tapAddButton();
    await tapButton(WidgetKeys.addGroup);
  }

  Future<void> toAddIdol() async {
    await tapAddButton();
    await tapButton(WidgetKeys.addIdol);
  }

  Future<void> toAddArtist() async {
    await tapAddButton();
    await tapButton(WidgetKeys.addArtist);
  }

  Future<void> toUserInfo() async {
    await tapButton(WidgetKeys.userAvatar);
  }

  Future<void> toEditUser() async {
    await toUserInfo();
    await tapTopBarMenu();
    await tapEdit();
  }
}
