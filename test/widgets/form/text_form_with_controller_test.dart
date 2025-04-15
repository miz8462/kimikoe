import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/widgets/form/text_form_with_controller.dart';

import '../../test_utils/mocks/logger.mocks.dart';
import '../../test_utils/test_widgets.dart';

void main() {
  logger = MockLogger();

  testWidgets('TextFormWithControllerウィジェット', (WidgetTester tester) async {
    final formKey = GlobalKey<FormState>();
    final label = 'Test Label';
    final controller = TextEditingController();
    final focusNode = FocusNode();
    String? savedText;

    String? mockValidator(String? value) {
      if (value == null || value.isEmpty) {
        return '入力してください';
      }
      return null;
    }

    void mockOnSaved(String? text) {
      savedText = text;
      logger.i('Saved: $text');
    }

    await tester.pumpWidget(
      buildTestWidget(
        child: Form(
          key: formKey,
          child: TextFormWithController(
            focusNode: focusNode,
            label: label,
            validator: mockValidator,
            onSaved: mockOnSaved,
            controller: controller,
          ),
        ),
      ),
    );

    expect(find.text(label), findsOneWidget);

    // フォーカス動作の確認
    await tester.tap(find.byType(TextFormField));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    // 空の値でヴァリデーションを検証
    await tester.enterText(find.byType(TextFormField), '');
    await tester.pump();
    formKey.currentState!.validate();
    await tester.pump();
    expect(find.text('入力してください'), findsOneWidget);

    // テキスト変更
    final newText = 'New Text';
    await tester.enterText(find.byType(TextFormField), newText);
    await tester.pump();
    expect(controller.text, newText);
    expect(find.text(newText), findsOneWidget);

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
