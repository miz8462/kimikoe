import '../test_utils/mocks/mock_logger.dart';
import '../test_utils/test_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:mockito/mockito.dart';

void main() {
  // MockLoggerを各テスト前に初期化
  late MockLogger mockLogger;
  setUp(() {
    mockLogger = MockLogger();
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
                  logger: mockLogger,
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
      verify(mockLogger.i('メッセージログ')).called(1);
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
                  logger: mockLogger,
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

      // ログの確認: `mockLogger.i` が1回呼び出されたことを検証
      verify(mockLogger.e('エラーログ')).called(1);
      // SnackBarの表示確認
      expect(find.text('エラーログ'), findsOneWidget);
    });
  });
}
