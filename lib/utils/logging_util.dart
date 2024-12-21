import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';

void logAsyncValue<T>({
  required AsyncValue<T> asyncValue,
}) {
  asyncValue.when(
    data: (data) {
      if (data is List) {
        logger.i('${data.length} 個のアイテムを含むリストの取得に成功しました');
      } else {
        logger.i('データの取得に成功しました');
      }
    },
    loading: () {
      logger.i('データを取得中...');
    },
    error: (error, stack) {
      logger.e(
        'データの取得に失敗しました',
        error: error,
        stackTrace: stack,
      );
    },
  );
}
