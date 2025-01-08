import 'package:flutter_test/flutter_test.dart';

Future<void> waitForCondition(
  WidgetTester tester,
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
