import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:robot/robot.dart';

class CustomRobot<T extends Widget> extends Robot<Widget> {
  CustomRobot(super.tester);

  Future<void> ensureVisibleWidget(String keyValue) async {
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(Key(keyValue)));
    await tester.pumpAndSettle();
  }

  Future<void> ensureVisibleWidgetByIndex({
    required int index,
    required Type widgetType,
  }) async {
    final finder = find.byType(widgetType);
    final matches = finder.evaluate();

    if (matches.isEmpty) {
      throw Exception('No $widgetType widgets found on screen');
    }
    if (matches.length <= index) {
      throw Exception(
        // ignore: lines_longer_than_80_chars
        'Index $index out of range for $widgetType (found ${matches.length} widgets)',
      );
    }

    await tester.ensureVisible(finder.at(index));
  }

  Future<void> ensureVisibleWidgetWithText({
    required Type widgetType,
    String? childText, // オプションで子要素のテキストを指定
  }) async {
    final finder = find.byType(widgetType);
    final matches = finder.evaluate();

    if (matches.isEmpty) {
      throw Exception('No $widgetType widgets found on screen');
    }

    // 子要素のテキストでフィルタリング
    Iterable<Element> filteredMatches = matches;
    if (childText != null) {
      filteredMatches = matches.where((element) {
        final textFinder = find.descendant(
          of: find.byElementPredicate((e) => e == element),
          matching: find.text(childText),
        );
        return textFinder.evaluate().isNotEmpty;
      });
    }

    final filteredList = filteredMatches.toList();
    if (filteredList.isEmpty) {
      throw Exception('No $widgetType widgets with text "$childText" found');
    }

    // 最初に見つかったウィジェットを可視化
    await tester.ensureVisible(
      find.byElementPredicate(
        (element) => element == filteredList.first,
      ),
    );
  }

  Future<void> tapWidget(String keyValue) async {
    await ensureVisibleWidget(keyValue);
    await tester.tap(find.byKey(Key(keyValue)));
    await tester.pumpAndSettle();
  }

  Future<void> tapFirstInList(String keyValue) async {
    await tester.tap(find.byKey(Key(keyValue)).first);
    await tester.pumpAndSettle();
  }

  Future<void> tapLastInList(String keyValue) async {
    await tester.tap(find.byKey(Key(keyValue)).last);
    await tester.pumpAndSettle();
  }

  Future<void> enterTextByKey({
    required String keyValue,
    required String enterValue,
  }) async {
    await ensureVisibleWidget(keyValue);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key(keyValue)), enterValue);
    await tester.pumpAndSettle();

    // フォーカスを外す
    FocusScope.of(tester.element(find.byKey(Key(keyValue)))).unfocus();
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
      throw Exception('ウィジェットが見つかりませんでした: $finder');
    }
  }

  Future<void> waitForWidget(Type widget) async {
    await waitForCondition(find.byType(widget));
  }

  Future<void> expectWidget(Type widget) async {
    await waitForWidget(widget);
    expect(find.byType(widget), findsOneWidget);
  }

  Future<void> expectIconOnWidget({
    required IconData icon,
    required Type widget,
  }) async {
    expect(
      find.descendant(of: find.byType(widget), matching: find.byIcon(icon)),
      findsOneWidget,
    );
  }

  Future<void> expectKey(Key key) async {
    expect(find.byKey(key), findsOneWidget);
  }
}
