import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/screens/posts/add_idol.dart';

import 'custom_robot.dart';

class NavigationRobot extends CustomRobot {
  NavigationRobot(super.tester);

  Future<void> tapAddButton() async {
    await tapWidget(WidgetKeys.addButton);
  }

  Future<void> tapTopBarMenu() async {
    await tapWidget(WidgetKeys.topBarMenu);
  }

  Future<void> tapEdit() async {
    await tapWidget(WidgetKeys.edit);
  }

  Future<void> tapDeleteMenu() async {
    await tapWidget(WidgetKeys.delete);
  }

  Future<void> tapLogoutMenu() async {
    await tapWidget(WidgetKeys.logout);
  }

  Future<void> toSongList({String groupName = 'test-group-not-delete'}) async {
    await ensureVisibleWidget(groupName);
    await tapWidget(groupName);
  }

  Future<void> toSongInfo() async {
    await toSongList();
    await tapFirstInList(WidgetKeys.songCard);
  }

  Future<void> toEditSong() async {
    await toSongInfo();
    await tapTopBarMenu();
    await tapEdit();
  }

  Future<void> toGroupDetail() async {
    await toSongList();
    await tapWidget(WidgetKeys.groupCardM);
  }

  Future<void> toEditGroup() async {
    await toGroupDetail();
    await tapTopBarMenu();
    await tapEdit();
  }

  Future<void> toIdolDetail() async {
    await toGroupDetail();
    await tapLastInList(WidgetKeys.members);
  }

  Future<void> toEditIdol() async {
    await toIdolDetail();
    await tapTopBarMenu();
    await tapEdit();
    await waitForWidget(AddIdolScreen);
  }

  Future<void> toAddSong() async {
    await tapAddButton();
    await tapWidget(WidgetKeys.addSong);
  }

  Future<void> toAddGroup() async {
    await tapAddButton();
    await tapWidget(WidgetKeys.addGroup);
  }

  Future<void> toAddIdol() async {
    await tapAddButton();
    await tapWidget(WidgetKeys.addIdol);
  }

  Future<void> toAddArtist() async {
    await tapAddButton();
    await tapWidget(WidgetKeys.addArtist);
  }

  Future<void> toUserInfo() async {
    await tapWidget(WidgetKeys.userAvatar);
  }

  Future<void> toEditUser() async {
    await toUserInfo();
    await tapTopBarMenu();
    await tapEdit();
  }

  Future<void> tapDeleteYes() async {
    final deleteAlert = find.byKey(Key(WidgetKeys.deleteIdol));
    final deleteYes = find.byKey(Key(WidgetKeys.deleteYes));
    await tester.pump(Duration(milliseconds: 500)); // アラートが表示されるのを待つ
    await tester.tap(find.descendant(of: deleteAlert, matching: deleteYes));
    await tester.pump(Duration(milliseconds: 500));
  }
}
