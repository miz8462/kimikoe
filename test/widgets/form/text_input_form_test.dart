import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/widgets/form/text_input_form.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('InputFormウィジェット', (WidgetTester tester) async {
    final formKey = GlobalKey<FormState>();
    final label = 'Test Label';
    String? savedText;
    final initialValue = 'Initial Value';

    void mockOnSaved(String? text) {
      savedText = text;
    }

    String? mockValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '入力してください';
      }
      return null;
    }

    await tester.pumpWidget(
      buildTestWidget(
        child: Form(
          key: formKey,
          child: InputForm(
            label: label,
            onSaved: mockOnSaved,
            initialValue: initialValue,
            validator: mockValidator,
          ),
        ),
      ),
    );

    // 初期化の確認
    expect(find.text(label), findsOneWidget);
    expect(find.text(initialValue), findsOneWidget);

    // 空の値でヴァリデーションを検証
    await tester.enterText(find.byType(TextFormField), '');
    await tester.pump();
    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('入力してください'), findsOneWidget);

    // テキスト変更
    final newText = 'New Text';
    await tester.enterText(find.byType(TextFormField), newText);

    // エラーメッセージが消えてることを確認
    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('入力してください'), findsNothing);

    // フォーム内容の保存の確認
    formKey.currentState!.save();
    await tester.pump();
    expect(savedText, newText);
  });
}
