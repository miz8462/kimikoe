import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/utils/logging_util.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/mocks/logger.mocks.dart';


void main() {
  setUpAll(() {
      logger = MockLogger();
    });
  group('logAsyncValue関数', () {
    
    test('データが取得された場合、成功ログ（リスト）', () {
      final asyncValue = AsyncValue.data([1, 2, 3]);

      logAsyncValue(asyncValue:asyncValue);

      verify(logger.i('3 個のアイテムを含むリストの取得に成功しました'));
    });
    test('データが取得された場合、成功ログ（その他のデータ）', () {
      final asyncValue = AsyncValue.data('Some Data');

      logAsyncValue(asyncValue:asyncValue);

      verify(logger.i('データの取得に成功しました'));
    });
    test('データが取得中の場合、ローディングログ', () {
      final asyncValue = AsyncValue<dynamic>.loading();

      logAsyncValue(asyncValue:asyncValue);

      verify(logger.i('データを取得中...'));
    });
    test('データが取得に失敗した場合、エラーログ', () {
      final asyncValue = AsyncValue<Object>.error('Error', StackTrace.current);

      logAsyncValue(asyncValue:asyncValue);
      verify(
        logger.e(
          'データの取得に失敗しました',
          error: 'Error',
          stackTrace: anyNamed('stackTrace'),
        ),
      ).called(1);
    });
  });
}
