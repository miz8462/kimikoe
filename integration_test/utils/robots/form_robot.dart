import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';
import 'package:path_provider/path_provider.dart';

import 'custom_robot.dart';

class FormRobot extends CustomRobot<Form> {
  FormRobot(super.tester);

  Future<void> tapSubmitButton() async {
    logger.d('ここだよ～');
    await ensureVisibleWidget(WidgetKeys.submit);
    await tester.pumpAndSettle();
    logger.d('ここだよ～1');
    await tapWidget(WidgetKeys.submit);
  }

  Future<void> enterName(String name) async {
    await enterTextByKey(keyValue: WidgetKeys.name, enterValue: name);
  }

  Future<void> enterTitle(String title) async {
    await enterTextByKey(keyValue: WidgetKeys.title, enterValue: title);
  }

  Future<void> enterLyric(String lyric) async {
    await enterTextByKey(keyValue: WidgetKeys.lyric0, enterValue: lyric);
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

  Future<void> pickDate(String expectDate, String keyValue) async {
    // 日付フィールドまでスクロール
    await ensureVisibleWidget(keyValue);
    await tester.pumpAndSettle();

    // TextFormFieldを見つけてタップ
    final dateFormField = find.descendant(
      of: find.byKey(Key(keyValue)),
      matching: find.byType(TextFormField),
    );

    await tester.ensureVisible(dateFormField);
    await tester.pumpAndSettle();

    await tester.tap(dateFormField);
    await tester.pumpAndSettle();

    // ピッカーのスクロール
    final scroll = find.byType(ListWheelScrollView).first;
    await tester.ensureVisible(scroll);
    await tester.pumpAndSettle();

    await tester.drag(scroll, const Offset(0, -100));
    await tester.pumpAndSettle();

    // ピッカーの外をタップして値を確定
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.text(expectDate), findsOneWidget);
  }

  Future<void> pickNumber(String expectYear, String keyValue) async {
    final yearFormField = find.descendant(
      of: find.byKey(Key(keyValue)),
      matching: find.byType(TextFormField),
    );
    await tester.ensureVisible(yearFormField);

    await tester.tap(yearFormField);
    await tester.pumpAndSettle();

    // picker
    final scroll = find.byType(ListWheelScrollView);
    await tester.ensureVisible(scroll);
    await tester.pumpAndSettle();
    await tester.drag(scroll, const Offset(0, -100));
    await tester.pumpAndSettle();

    // Pickerの外をタップして値を確定
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    // -100ドラッグしたら+3される
    expect(find.text(expectYear), findsOneWidget);
  }

  Future<void> pickColor() async {
    await ensureVisibleWidget(WidgetKeys.color);

    await tapWidget(WidgetKeys.color);
    await tester.pumpAndSettle();

    await tester.tap(
      find
          .descendant(
            of: find.byType(BlockPicker),
            matching: find.byType(RichText),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    final redButton = find.byWidgetPredicate(
      (widget) =>
          widget is OutlinedButton &&
          (widget.style?.backgroundColor?.resolve({}) == Colors.red),
    );
    expect(redButton, findsOneWidget);
  }

  Future<void> selectImage() async {
    await _setMockImagePicker();

    await ensureVisibleWidget(WidgetKeys.image);
    await tapWidget(WidgetKeys.image);
    await tester.pumpAndSettle();
  }

  Future<void> selectGroup({String groupName = 'タイトル未定'}) async {
    await tapWidget(WidgetKeys.group);
    await tester.pumpAndSettle();

    final group = find.text(groupName).last; // ふたつ見つかるのでlast
    await tester.ensureVisible(group);
    await tester.pumpAndSettle();

    await tester.tap(group);
    await tester.pumpAndSettle();
  }

  Future<void> selectSinger() async {
    await tapWidget(WidgetKeys.singer0);
    await tester.pumpAndSettle();

    await tester.tap(find.text('阿部葉菜').last);
    await tester.pumpAndSettle();
  }

  Future<void> selectLyricist() async {
    // まずLyricistフィールドまでスクロール
    await ensureVisibleWidget(WidgetKeys.lyricist);
    await tester.pumpAndSettle();

    // ドロップダウンをタップ
    await tapWidget(WidgetKeys.lyricist);
    await tester.pumpAndSettle();

    // ドロップダウンメニューの選択肢を見つける
    final menuItem = find.text('otsumami').last;

    // メニュー項目が表示されるまで少し待つ
    await tester.pump(const Duration(milliseconds: 500));

    // メニュー項目までスクロール
    await tester.ensureVisible(menuItem);
    await tester.pumpAndSettle();

    // メニュー項目をタップ
    await tester.tap(menuItem, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  Future<void> selectComposer() async {
    // まずComposerフィールドまでスクロール
    await ensureVisibleWidget(WidgetKeys.composer);
    await tester.pumpAndSettle();

    // ドロップダウンをタップ
    await tapWidget(WidgetKeys.composer);
    await tester.pumpAndSettle();

    // ドロップダウンメニューの選択肢を見つける
    final menuItem = find.text('otsumami').last;

    // メニュー項目が表示されるまで少し待つ
    await tester.pump(const Duration(milliseconds: 500));

    // メニュー項目までスクロール
    await tester.ensureVisible(menuItem);
    await tester.pumpAndSettle();

    // メニュー項目をタップ
    await tester.tap(menuItem, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  void expectSuccessMessage({
    required String dataType,
    required String name,
  }) {
    expect(find.text('$dataTypeを登録しました: $name'), findsOneWidget);
  }

  void expectValidationMessage({
    String? dataType = '名前',
  }) {
    expect(find.text('$dataTypeを入力してください'), findsOneWidget);
  }

  Future<void> deleteTestData({
    required String table,
    required String name,
    String columnName = ColumnName.name,
  }) async {
    await deleteDataByName(table: table, targetColumn: columnName, name: name);
    logger.i('テストデータを削除しました');
  }

  Future<void> _setMockImagePicker() async {
    const channel = MethodChannel('plugins.flutter.io/image_picker');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'pickImage') {
          // テスト用画像のパスを取得
          final byteData = await rootBundle.load('assets/test.jpg');
          final tempDir = await getTemporaryDirectory();
          final tempPath = tempDir.path;
          final file = File('$tempPath/test.jpg');
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
