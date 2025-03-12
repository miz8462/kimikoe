import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/widgets/text/one_line_text.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('OneLineTextウィジェット。テキストがオーバーフローした場合、省略される', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        child: SizedBox(
          width: 100,
          child: OneLineText(
            'テストメッセージはハイパー長いので省略されるはず！！！',
            fontSize: 20,
            textColor: Colors.green,
          ),
        ),
      ),
    );

    final textFinder = find.byType(Text);
    expect(textFinder, findsOneWidget);

    final textWidget = tester.widget<Text>(textFinder);
    final textStyle = textWidget.style;

    expect(textWidget.maxLines,1);
    expect(textWidget.overflow, TextOverflow.ellipsis); // ellipsisで省略
    expect(textStyle?.fontSize, 20);
    expect(textStyle?.color, Colors.green);
  });
}
