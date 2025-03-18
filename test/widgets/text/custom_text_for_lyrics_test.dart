import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/widgets/text/custom_text_for_lyrics.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('CustomTextForLyricsが表示される', (tester) async {
    final text = 'テストメッセージ';
    final color = Colors.green;

    await tester.pumpWidget(
      buildTestWidget(
        child: CustomTextForLyrics(
          text,
          color: color,
        ),
      ),
    );

    // 色丸パートの検証
    // Rowの中のPaddingウィジェットを取得。二つ見付かるのでtopが2.0になっているPaddingを選択。
    final paddingWidgets = tester.widgetList<Padding>(
      find.descendant(
        of: find.byType(CustomTextForLyrics),
        matching: find.byType(Padding),
      ),
    );
    final targetPadding = paddingWidgets
        .firstWhere((p) => p.padding == const EdgeInsets.only(top: 2));
    expect(targetPadding.padding, const EdgeInsets.only(top: 2));

    final container = tester.widget<Container>(find.byType(Container));
    expect(container.constraints?.maxHeight, circleSize);
    expect(container.constraints?.maxWidth, circleSize);

    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, color);

    // テキストパートの検証
    expect(find.text(text), findsOneWidget);

    final textWidget = tester.widget<Text>(find.text(text));
    expect(textWidget.style?.fontSize, 16);
    expect(textWidget.style?.color, textDark);
  });
}
