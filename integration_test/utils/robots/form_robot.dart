import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';

import 'custom_robot.dart';

class FormRobot extends CustomRobot<Form> {
  FormRobot(super.tester);

  Future<void> ensureSubmitButton() async {
    await ensureVisibleButton(WidgetKeys.submit);
  }

  Future<void> tapSubmitButton() async {
    await tapButton(WidgetKeys.submit);
  }

  Future<void> enterName(String name) async {
    await enterTextByKey(keyValue: WidgetKeys.name, enterValue: name);
  }

  Future<void> enterTitle(String title) async {
    await enterTextByKey(keyValue: WidgetKeys.title, enterValue: title);
  }

  Future<void> enterOfficial(String official) async {
    await enterTextByKey(keyValue: WidgetKeys.official, enterValue: official);
  }

  Future<void> enterTwitter(String twitter) async {
    await enterTextByKey(keyValue: WidgetKeys.twitter, enterValue: twitter);
  }

  Future<void> enterInstagram(String instagram) async {
    await enterTextByKey(keyValue: WidgetKeys.instagram, enterValue: instagram);
  }

  Future<void> enterSchedule(String schedule) async {
    await enterTextByKey(keyValue: WidgetKeys.schedule, enterValue: schedule);
  }

  Future<void> enterHometown(String hometown) async {
    await enterTextByKey(keyValue: WidgetKeys.hometown, enterValue: hometown);
  }

  Future<void> enterComment(String comment) async {
    await enterTextByKey(keyValue: WidgetKeys.comment, enterValue: comment);
  }

  void expectAddArtistSuccessMessage() {
    expect(find.text('アーティストを登録しました: test-artist'), findsOneWidget);
  }

  void expectValidationMessage() {
    expect(find.text('アーティスト名を入力してください。'), findsOneWidget);
  }

  Future<void> deleteTestArtist(String name) async {
    await deleteDataByName(table: TableName.artists, name: name);
  }
}
