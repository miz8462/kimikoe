import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/screens/posts/add_idol.dart';

import 'custom_robot.dart';

class NavigationRobot extends CustomRobot {
  NavigationRobot(super.tester);

  Future<void> tapHomeButon() async {
    await tapWidget(WidgetKeys.homeButton);
  }

  Future<void> tapFavoriteButton() async {
    await tapWidget(WidgetKeys.favoriteButton);
  }

  Future<void> tapGroupTab() async {
    await tapWidget(WidgetKeys.groupTab);
  }

  Future<void> tapSongTab() async {
    await tapWidget(WidgetKeys.songTab);
  }

  Future<void> tapAddButton() async {
    await tapWidget(WidgetKeys.addButton);
  }

  Future<void> _tapTopBarMenu() async {
    await tapWidget(WidgetKeys.topBarMenu);
  }

  Future<void> _tapEdit() async {
    await tapWidget(WidgetKeys.edit);
  }

  Future<void> tapMenuAndEdit() async {
    await _tapTopBarMenu();
    await _tapEdit();
  }

  Future<void> tapDelete() async {
    await tapWidget(WidgetKeys.delete);
  }

  Future<void> tapMenuAndDelete() async {
    await _tapTopBarMenu();
    await tapDelete();
  }

  Future<void> _tapLogout() async {
    await tapWidget(WidgetKeys.logout);
  }

  Future<void> tapMenuAndLogout() async {
    await _tapTopBarMenu();
    await _tapLogout();
  }

  Future<void> tapStar() async {
    await tapWidget(WidgetKeys.star);
  }

  Future<void> toSongList({String groupName = 'test-group-not-delete'}) async {
    await ensureVisibleWidget(groupName);
    await tester.pumpAndSettle();
    await tapWidget(groupName);
  }

  Future<void> toSongInfo() async {
    await toSongList();
    await tapFirstInList(WidgetKeys.songCard);
  }

  Future<void> toTestSong() async {
    await toSongList();
    await tapWidget(WidgetKeys.testSong);
  }

  Future<void> toEditSong() async {
    await toSongInfo();
    await tapMenuAndEdit();
  }

  Future<void> toGroupDetail() async {
    await toSongList();
    await tapWidget(WidgetKeys.groupCardM);
  }

  Future<void> toEditGroup() async {
    await toGroupDetail();
    await tapMenuAndEdit();
  }

  Future<void> toIdolDetail() async {
    await toGroupDetail();
    await tapLastInList(WidgetKeys.members);
  }

  Future<void> toEditIdol() async {
    await toIdolDetail();
    await tapMenuAndEdit();

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
    await tapMenuAndEdit();
  }

  Future<void> tapDeleteYes() async {
    final deleteAlert = find.byKey(Key(WidgetKeys.deleteIdol));
    final deleteYes = find.byKey(Key(WidgetKeys.deleteYes));
    await tester.pump(Duration(milliseconds: 500)); // アラートが表示されるのを待つ
    await tester.tap(find.descendant(of: deleteAlert, matching: deleteYes));
    await tester.pump(Duration(milliseconds: 500));
  }
}
