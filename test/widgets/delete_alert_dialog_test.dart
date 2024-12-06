import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';

import '../test_utils/test_widgets.dart';

void main() {
  testWidgets(
    'DeleteAlertDialogウィジェット',
    (tester) async {
      var deleteCalled = false;
      Future<void> onDelete() async {
        deleteCalled = true;
      }

      await tester.pumpWidget(
        buildTestWidget(
          child: DeleteAlertDialog(
            onDelete: onDelete,
            successMessage: '削除に成功しました',
            errorMessage: '削除に失敗しました',
          ),
        ),
      );

      expect(find.byType(AlertDialog), findsOneWidget);

      expect(find.text('本当に削除しますか？'), findsOneWidget);
      expect(find.text('削除したデータは復元できません。\nそれでも削除しますか？'), findsOneWidget);

      await tester.tap(find.text('はい'));
      expect(deleteCalled, true);

      // スナックバーが表示されるのを待つ
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text('削除に成功しました'), findsOneWidget);
    },
  );
}