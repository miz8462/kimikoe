import 'package:flutter/material.dart';

// テスト用ウィジェットの雛形
Widget buildTestWidget({
  required Widget child,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return child;
        },
      ),
    ),
  );
}
