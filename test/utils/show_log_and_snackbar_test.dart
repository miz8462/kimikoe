import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/mocks/logger_mock.dart';
import '../test_utils/test_widgets.dart';

void main() {
  setUpAll(() {
    logger = MockLogger();
  });
  group('showLogAndSnackBar関数のテスト', () {
    testWidgets('ログとスナックバーの表示テスト', (tester) async {
      final testWidget = buildTestWidget(
        child: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                showLogAndSnackBar(
                  context: context,
                  message: 'メッセージログ',
                );
              },
              child: Text('Show SnackBar'),
            );
          },
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(ElevatedButton));
      // ボタンをタップした後や、setState を呼び出した後など、状態が変化した後の最新の状態をウィジェットツリーに反映させる
      await tester.pumpAndSettle();

      // ログの確認: `mockLogger.i` が1回呼び出されたことを検証
      verify(logger.i('メッセージログ')).called(1);
      // SnackBarの表示確認
      expect(find.text('メッセージログ'), findsOneWidget);
    });
    testWidgets('エラー時のログとスナックバーの表示テスト', (tester) async {
      final testWidget = buildTestWidget(
        child: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                showLogAndSnackBar(
                  context: context,
                  message: 'エラーログ',
                  isError: true,
                );
              },
              child: Text('Show Error SnackBar'),
            );
          },
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(ElevatedButton));
      // ボタンをタップした後や、setState を呼び出した後など、状態が変化した後の最新の状態をウィジェットツリーに反映させる
      await tester.pumpAndSettle();

      // ログの確認: `logger.i` が1回呼び出されたことを検証
      verify(logger.e('エラーログ')).called(1);
      // SnackBarの表示確認
      expect(find.text('エラーログ'), findsOneWidget);
    });
  });
}
