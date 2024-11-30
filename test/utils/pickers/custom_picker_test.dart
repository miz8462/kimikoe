import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/utils/pickers/custom_picker.dart';

void main() {
  late DateTime currentTime;
  late DateTime minTime;
  late DateTime maxTime;
  late picker.LocaleType locale;

  // 各テスト前に共通部分を初期化
  void commonSetUp() {
    currentTime = DateTime(2000);
    minTime = DateTime(1990);
    maxTime = DateTime.now();
    locale = picker.LocaleType.jp;
  }

  group('CustomYearPickerテスト', () {
    late CustomYearPicker customYearPicker;
    setUp(() {
      commonSetUp();
      customYearPicker = CustomYearPicker(
        currentTime: currentTime,
        minTime: minTime,
        maxTime: maxTime,
        locale: locale,
      );
    });
    test('プロパティが正しく設定されていることをテスト', () {
      expect(customYearPicker.currentTime, currentTime);
      expect(customYearPicker.minTime, minTime);
      expect(customYearPicker.maxTime, maxTime);
      expect(customYearPicker.locale, locale);
    });
    test('layoutProportionsが期待通りのリストを返すことをテスト', () {
      expect(customYearPicker.layoutProportions(), [1, 0, 0]);
    });

    test('finalTimeが現在の年を変えることをテスト', () {
      expect(customYearPicker.finalTime(), DateTime(currentTime.year));
    });
  });
  group('CustomMonthDayPickerテスト', () {
    late CustomMonthDayPicker customMonthDayPicker;
    setUp(() {
      commonSetUp();
      customMonthDayPicker = CustomMonthDayPicker(
        currentTime: currentTime,
        minTime: minTime,
        maxTime: maxTime,
        locale: locale,
      );
    });
    test('プロパティが正しく設定されていることをテスト', () {
      expect(customMonthDayPicker.currentTime, currentTime);
      expect(customMonthDayPicker.minTime, minTime);
      expect(customMonthDayPicker.maxTime, maxTime);
      expect(customMonthDayPicker.locale, locale);
    });
    test('layoutProportionsが期待通りのリストを返すことをテスト', () {
      expect(customMonthDayPicker.layoutProportions(), [0, 1, 1]);
    });

    test('finalTimeが現在の年を変えることをテスト', () {
      expect(customMonthDayPicker.finalTime(),
          DateTime(0, currentTime.month, currentTime.day));
    });
  });
}
