import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/utils/pickers/int_picker.dart';

void main() {
  group(
    'IntPickerウィジェットテスト',
    () {
      testWidgets(
        '初期値と値の更新テスト',
        (tester) async {
          final controller = TextEditingController();

          // テストウィジェットの設定
          await tester.pumpWidget(
            CupertinoApp(
              // IntPicerはCupertinoPickerで作られている
              home: IntPicker(
                // アプリでは身長入力に用いるため、この数値範囲を設定
                startNum: 100,
                endNum: 200,
                initialNum: 160,
                controller: controller,
              ),
            ),
          );

          // 初期値の確認
          expect(controller.text, '160');
          logger.i('初期値: ${controller.text}');

          // 値の変更。アイテム10個分下へドラッグ
          // itemExtent: 35。
          // 10.1なのは10.0ピッタリだとドラッグ9だと認識されるから
          await tester.drag(
            find.byType(CupertinoPicker),
            Offset(0, -35.0 * 10.1),
          );
          await tester.pumpAndSettle();
          logger.i('変更後の値: ${controller.text}');

          expect(controller.text, '170');
        },
      );
    },
  );
}
