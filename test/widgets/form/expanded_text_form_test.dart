import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/widgets/form/expanded_text_form.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('ExpandedTextFormウィジェット', (WidgetTester tester) async {
    final label = 'Test Label';
    final initialValue = 'Initial Value';
    String? changedText;

    void mockOnTextChanged(String? text) {
      changedText = text;
      logger.i('on Changed Text: $text');
    }

    await tester.pumpWidget(
      buildTestWidget(
        child: ExpandedTextForm(
          onTextChanged: mockOnTextChanged,
          label: label,
          initialValue: initialValue,
        ),
      ),
    );

    // 初期化の確認
    expect(find.text(label), findsOneWidget);
    expect(find.text(initialValue), findsOneWidget);

    final formFieldFinder = find.byType(TextFormField);

    // テキスト変更
    await tester.enterText(formFieldFinder, 'New Text');
    await tester.pump();
    // 変更後のテキストを確認
    expect(find.text('New Text'), findsOneWidget);

    // フォームの保存
    final formState = tester.state<FormFieldState<String>>(formFieldFinder);
    formState.save();

    // onChangedが呼び出されたことを確認
    expect(changedText, 'New Text');
  });
}
