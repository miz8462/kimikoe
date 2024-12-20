import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/mocks/logger_mock.dart';
import '../test_utils/test_helpers.dart';

void main() {
  test('loggerProvider', () {
    final mockLogger = MockLogger();
    final container = createContainer(
      overrides: [loggerProvider.overrideWith((ref) => mockLogger)],
    );

    // Loggerインスタンスチェック
    final logger = container.read(loggerProvider);
    expect(logger, isA<Logger>());
    expect(logger, equals(mockLogger));

    // ログ出力チェック
    logger.i('test logger provider');
    verify(mockLogger.i('test logger provider')).called(1);
  });
}
