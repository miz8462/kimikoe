import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/utils/logging_util.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/mocks/logger_mock.dart';

void main() {
  group('logAsyncValue関数', () {
    late MockLogger mockLogger;
    setUp(() {
      mockLogger = MockLogger();
    });
    test('データが取得された場合、成功ログ（リスト）', () {
      final asyncValue = AsyncValue.data([1, 2, 3]);

      logAsyncValue(asyncValue, mockLogger);

      verify(mockLogger.i('3 個のアイテムを含むリストの取得に成功しました'));
    });
    test('データが取得された場合、成功ログ（その他のデータ）', () {
      final asyncValue = AsyncValue.data('Some Data');

      logAsyncValue(asyncValue, mockLogger);

      verify(mockLogger.i('データの取得に成功しました'));
    });
    test('データが取得中の場合、ローディングログ', () {
      final asyncValue = AsyncValue.loading();

      logAsyncValue(asyncValue, mockLogger);

      verify(mockLogger.i('データを取得中...'));
    });
    test('データが取得に失敗した場合、エラーログ', () {
      final asyncValue = AsyncValue.error('Error', StackTrace.current);

      logAsyncValue(asyncValue, mockLogger);
      verify(
        mockLogger.e(
          'データの取得に失敗しました',
          error: 'Error',
          stackTrace: anyNamed('stackTrace'),
        ),
      ).called(1);
    });
  });
}
