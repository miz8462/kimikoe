import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/widgets/text/styled_text.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('StyledText', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: StyledText(
          'テストメッセージ',
          fontSize: 20,
          textColor: Colors.green,
        ),
      ),
    );

    // テキストがウィジェットツリーに存在することを検証
    expect(find.text('テストメッセージ'), findsOneWidget);
    // テキストがウィジェットツリーに存在しているのでそれを取得。
    // テキストが存在しない場合エラーになるので順番大事
    final textWidget = tester.widget<Text>(find.text('テストメッセージ'));
    final textStyle = textWidget.style;

    expect(textStyle?.fontSize,20);
    expect(textStyle?.color,Colors.green);
  });
}
