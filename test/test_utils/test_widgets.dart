import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// テスト用ウィジェットの雛形
Widget buildTestWidget({
  required Widget child,
  List<Override>? overrides,
}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return child;
          },
        ),
      ),
    ),
  );
}
