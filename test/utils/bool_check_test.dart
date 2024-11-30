import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/utils/check.dart';

void main() {
  group('isInList関数のテスト', () {
    test('リストに名前が存在するかどうかをテスト', () {
      final list = [
        {ColumnName.name: 'Miu'},
        {ColumnName.name: 'Nanako'},
        {ColumnName.name: 'Nika'}
      ];

      // 名前が存在する場合
      expect(isInList(list, 'Miu'), isTrue);
      expect(isInList(list, 'Nika'), isTrue);

      // 名前が存在しない場合
      expect(isInList(list, 'Koharu'), isFalse);
      expect(isInList(list, null), isFalse);
    });
    test('リストが空の場合はfalseを返すことをテスト', () {
      final list = <Map<String, dynamic>>[];
      expect(isInList(list, 'Ito'), isFalse);
    });
  });
}
