import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/widgets/button/image_input.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils/mocks/image_picker_service_mock.dart';
import '../../test_utils/test_widgets.dart';

// TODO: 画像選択テスト
void main() {
  group('ImageInputウィジェット', () {
    testWidgets('ImageInputウィジェット初期状態テスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: ImageInput(label: 'test label', onPickImage: (_) {}),
        ),
      );

      final button = find.byType(StyledButton);
      expect(button, findsOneWidget);
      expect(find.text('test label'), findsOneWidget);
      final buttonWidget = tester.widget<StyledButton>(button);
      expect(buttonWidget.backgroundColor, equals(mainColor.withOpacity(0.8)));
    });

    testWidgets('画像選択機能のテスト', (WidgetTester tester) async {
      final mockImagePickerService = MockImagePickerService();
      const filePath = 'path/to/dummy/image.png';

      // モックの設定
      when(
        mockImagePickerService.pickImage(source: ImageSource.gallery),
      ).thenAnswer((_) async => Future.value(XFile(filePath)));

      var imagePicked = false;
      void onPickImage(File image) {
        imagePicked = true;
        expect(image.path, filePath);
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageInput(
              label: 'test label',
              onPickImage: onPickImage,
              imagePickerService: mockImagePickerService, // モックの注入
            ),
          ),
        ),
      );

      // 画像選択ボタンが表示されていることを確認
      final button = find.byType(StyledButton);
      expect(button, findsOneWidget);

      // 画像選択ボタンをタップ
      await tester.tap(button);
      await tester.pumpAndSettle();

      // 画像が選択され、コールバックが呼ばれたことを確認
      expect(imagePicked, isTrue);

      // モックの呼び出しを検証
      verify(mockImagePickerService.pickImage(source: ImageSource.gallery))
          .called(1);
    });
  });
}
