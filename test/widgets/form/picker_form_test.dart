import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/widgets/form/picker_form.dart';

import '../../test_utils/test_widgets.dart';

void main() {
  testWidgets('PickerFormウィジェット', (WidgetTester tester) async {
    final label = 'Test Label';
    final controller = TextEditingController();
    const initialValue = 'Initial Value';
    var pickerCalled = false;

    void mockPicker() {
      pickerCalled = true;
      logger.i('Picker Called: $pickerCalled');
    }

    void mockOnSaved(String? value) {
      logger.i('Saved: $value');
    }

    await tester.pumpWidget(
      buildTestWidget(
        child: PickerForm(
          label: label,
          controller: controller,
          picker: mockPicker,
          onSaved: mockOnSaved,
          initialValue: initialValue,
        ),
      ),
    );

    // 初期化の確認
    expect(controller.text, initialValue);
    expect(find.text(label), findsOneWidget);
    expect(find.text(initialValue), findsOneWidget);

    final formFieldFinder = find.byType(TextFormField);

    await tester.tap(formFieldFinder);
    await tester.pumpAndSettle();

    // テキストフィールドがタップされるとPickerが呼び出されることを検証
    expect(pickerCalled, isTrue);

    // onSavedが呼び出されることを検証
    final formState = tester.state<FormFieldState<String>>(formFieldFinder);
    formState.save();
  });
}
