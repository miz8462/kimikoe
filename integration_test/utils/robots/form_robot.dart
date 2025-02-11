import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';

import 'custom_robot.dart';

class FormRobot extends CustomRobot<Form> {
  FormRobot(super.tester);

  Future<void> ensureSubmitButton() async {
    await ensureVisibleWidget(WidgetKeys.submit);
  }

  Future<void> tapSubmitButton() async {
    await tapWidget(WidgetKeys.submit);
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

  Future<void> selectYear() async {
    await tester.tap(
      find.descendant(
        of: find.byKey(Key(WidgetKeys.year)),
        matching: find.byType(TextFormField),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(ListWheelScrollView));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -100));
    await tester.pumpAndSettle();

    // Pickerの外をタップして値を確定
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.text('2023'), findsOneWidget);
  }

  void expectSuccessMessage({
    required String dataType,
    required String name,
  }) {
    expect(find.text('$dataTypeを登録しました: $name'), findsOneWidget);
  }

  void expectValidationMessage(
    String dataType,
  ) {
    expect(find.text('$dataType名を入力してください。'), findsOneWidget);
  }

  Future<void> deleteTestData({
    required String table,
    required String name,
  }) async {
    await deleteDataByName(table: table, name: name);
  }
}
