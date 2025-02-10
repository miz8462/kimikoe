import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'custom_robot.dart';

class FormRobot extends CustomRobot<Form> {
  FormRobot(super.tester);

  Future<void> enterName(String name) async {
    await enterTextByKey(keyValue: 'name', enterValue: name);
  }

  Future<void> enterTitle(String title) async {
    await enterTextByKey(keyValue: 'title', enterValue: title);
  }

  Future<void> enterOfficial(String official) async {
    await enterTextByKey(keyValue: 'official', enterValue: official);
  }

  Future<void> enterTwitter(String twitter) async {
    await enterTextByKey(keyValue: 'twitter', enterValue: twitter);
  }

  Future<void> enterInstagram(String instagram) async {
    await enterTextByKey(keyValue: 'instagram', enterValue: instagram);
  }

  Future<void> enterSchedule(String schedule) async {
    await enterTextByKey(keyValue: 'schedule', enterValue: schedule);
  }

  Future<void> enterHometown(String hometown) async {
    await enterTextByKey(keyValue: 'hometown', enterValue: hometown);
  }

  Future<void> enterComment(String comment) async {
    await enterTextByKey(keyValue: 'comment', enterValue: comment);
  }

  void expectAddArtistSuccessMessage() {
    expect(find.text('アーティストを登録しました: test-artist'), findsOneWidget);
  }
}
