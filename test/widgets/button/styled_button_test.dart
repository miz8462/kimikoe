import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('StyledButtonウィジェット', (WidgetTester tester) async {
    final isSendingNotifier = ValueNotifier<bool>(false);
    await tester.pumpWidget(
      buildTestWidget(
        child: ValueListenableBuilder<bool>(
          valueListenable: isSendingNotifier,
          builder: (context, isSending, child) {
            return StyledButton(
              'test button',
              isSending: isSending,
              onPressed: () {
                isSendingNotifier.value = true;
              },
            );
          },
        ),
      ),
    );

    // 表示テスト
    expect(find.byType(StyledButton), findsOneWidget);
    final buttonStyle =
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).style;
    expect(buttonStyle?.backgroundColor?.resolve({}), mainColor);
    expect(
      buttonStyle?.shape?.resolve({}),
      RoundedRectangleBorder(
        borderRadius: borderRadius4,
      ),
    );
    expect(buttonStyle?.side?.resolve({}), BorderSide.none);
    expect(
      buttonStyle?.fixedSize?.resolve({}),
      const Size.fromWidth(double.maxFinite),
    );
    // テキスト確認
    expect(find.text('test button'), findsOneWidget);
    final textStyle = tester.widget<Text>(find.text('test button')).style;
    expect(textStyle?.color, textWhite);
    expect(textStyle?.fontSize, 20);

    // タップテスト
    await tester.tap(find.byType(StyledButton));
    await tester.pump();
    expect(isSendingNotifier.value, isTrue);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
