import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';
import 'package:path_provider/path_provider.dart';

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
    await tester.ensureVisible(
      find.descendant(
        of: find.byKey(Key(WidgetKeys.year)),
        matching: find.byType(TextFormField),
      ),
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(Key(WidgetKeys.year)),
        matching: find.byType(TextFormField),
      ),
    );
    await tester.pumpAndSettle();

    // picker
    await tester.ensureVisible(find.byType(ListWheelScrollView));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -100));
    await tester.pumpAndSettle();

    // Pickerの外をタップして値を確定
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    // -100ドラッグしたら2023になる
    expect(find.text('2023'), findsOneWidget);
  }

  Future<void> selectImage() async {
    await _setMockImagePicker();

    await ensureVisibleWidget(WidgetKeys.image);
    await tapWidget(WidgetKeys.image);
    await tester.pumpAndSettle();
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
    expect(find.text('$dataType名を入力してください'), findsOneWidget);
  }

  Future<void> deleteTestData({
    required String table,
    required String name,
  }) async {
    await deleteDataByName(table: table, name: name);
    logger.i('テストデータを削除しました');
  }

  Future<void> _setMockImagePicker() async {
    const channel = MethodChannel('plugins.flutter.io/image_picker');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'pickImage') {
          // テスト用画像のパスを取得
          final byteData = await rootBundle.load('assets/test_image.jpg');
          final tempDir = await getTemporaryDirectory();
          final tempPath = tempDir.path;
          final file = File('$tempPath/test_image.jpg');
          await file.writeAsBytes(
            byteData.buffer
                .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
          );
          return file.path;
        }
        return null;
      },
    );
  }
}
