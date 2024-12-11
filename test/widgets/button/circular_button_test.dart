import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/widgets/button/circular_button.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('CircularButtonウィジェット', (WidgetTester tester) async {
    var isPressed = false;
    await tester.pumpWidget(
      buildTestWidget(
        child: CircularButton(
          onPressed: () {
            isPressed = true;
          },
        ),
      ),
    );

    // 表示テスト
    expect(find.byType(CircularButton), findsOneWidget);
    final buttonStyle =
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).style;
    // resolveで現在の状態を取得
    expect(
      buttonStyle?.backgroundColor?.resolve({}),
      mainColor,
    );

    // タップテスト
    await tester.tap(find.byType(CircularButton));
    await tester.pump();
    expect(isPressed, true);
  });
}
