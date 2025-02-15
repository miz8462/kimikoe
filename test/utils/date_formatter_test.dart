import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';

void main() {
  group('date_formatterファイルのテスト', () {
    test('formatStyleに合った日時を返す', () {
      // テスト用の日時を設定
      final date = DateTime(2023, 12, 4, 14, 30);
      final formatStyle = 'yyyy/MM/dd';
      // 期待される結果
      final expected = '2023/12/04';
      // 関数の結果を確認
      final result = formatDateTimeToXXXX(date: date, formatStyle: formatStyle);
      expect(result, expected);
    });
    test('日本語で「月」「日」を付けて日付を返す', () {
      final date = '2023-01-22';
      final expected = '01月22日';

      final result = formatStringDateToJapaneseOnlyMonthAndDay(date);
      expect(result, expected);
    });
    test('日本語で「年」「月」「日」を付けて日付を返す', () {
      final date = '2000-01-22';
      final expected = '2000年01月22日';

      final result = formatStringDateToJapaneseWithYear(date);
      expect(result, expected);
    });
    test('MM/ddの形で日付を返す', () {
      final date = '2000-01-22';
      final expected = '01/22';

      final result = formatStringDateToMMdd(date);
      expect(result, expected);
    });
    test('yyyy/MM/ddの形で日付を返す', () {
      final date = '2000-01-22';
      final expected = '2000/01/22';

      final result = formatStringDateToSlash(date);
      expect(result, expected);
    });
  });
}
