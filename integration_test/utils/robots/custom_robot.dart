import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:robot/robot.dart';

class CustomRobot<T extends Widget> extends Robot<Widget> {
  CustomRobot(super.tester);

  Future<void> ensureVisibleButton(String keyValue) async {
    await tester.ensureVisible(find.byKey(Key(keyValue)));
    await tester.pumpAndSettle();
  }

  Future<void> tapButton(String keyValue) async {
    await tester.tap(find.byKey(Key(keyValue)));
    await tester.pumpAndSettle();
  }

  Future<void> tapFirstInList(String keyValue) async {
    await tester.tap(find.byKey(Key(keyValue)).first);
    await tester.pumpAndSettle();
  }

  Future<void> enterTextByKey({
    required String keyValue,
    required String enterValue,
  }) async {
    await tester.enterText(find.byKey(Key(keyValue)), enterValue);
    await tester.pumpAndSettle();
  }

  Future<void> waitForCondition(
    Finder finder, {
    int maxRetries = 10,
    Duration delay = const Duration(seconds: 1),
  }) async {
    var conditionMet = false;
    for (var i = 0; i < maxRetries; i++) {
      await tester.pumpAndSettle();
      if (finder.evaluate().isNotEmpty) {
        conditionMet = true;
        break;
      }
      await Future<void>.delayed(delay);
    }
    if (!conditionMet) {
      throw Exception('$finderが見つかりませんでした');
    }
  }

  Future<void> waitForScreen(Type screen) async {
    await waitForCondition(find.byType(screen));
  }

  Future<void> expectScreen(Type screen) async {
    await waitForScreen(screen);
    expect(find.byType(screen), findsOneWidget);
  }
}
