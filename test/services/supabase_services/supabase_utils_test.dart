import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_utils.dart';

import '../../test_utils/mocks/logger_mock.dart';

void main() {
  late final MockLogger mockLogger;

  setUpAll(() async {
    mockLogger = MockLogger();
    logger = mockLogger;
  });

  group('fetchSelectedDataIdFromName', () {
    final mockDataList = <Map<String, dynamic>>[
      {
        'id': 1,
        'name': 'test idol',
      },
      {
        'id': 2,
        'name': 'test idol2',
      },
    ];
    test('正常にデータIDを取得できる', () {
      final idolId = findDataIdByName(list: mockDataList, name: 'test idol');
      expect(idolId, 1);
    });
    test('指定された名前がない場合、例外をスローする', () {
      expect(
        () => findDataIdByName(
          list: mockDataList,
          name: 'test idol3',
        ),
        throwsStateError,
      );
    });
  });
}
