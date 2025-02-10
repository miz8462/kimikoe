import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

extension TestUtilEx on WidgetTester {
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    String description = '',
  }) async {
    var found = false;
    final timer = Timer(
      timeout,
      () => throw TimeoutException('Pump until has timed out $description'),
    );
    while (!found) {
      await pump();
      found = any(finder);
    }
    timer.cancel();
  }
}
