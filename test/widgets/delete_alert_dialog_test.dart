import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';

import '../test_utils/mocks/logger.mocks.dart';
import '../test_utils/test_widgets.dart';

void main() {
  logger = MockLogger();
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

      await tester.tap(find.byKey(Key(WidgetKeys.deleteYes)));
      expect(deleteCalled, true);
      
      // スナックバーが表示されるのを待つ
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text('削除に失敗しました'), findsOneWidget);
    },
  );
}
