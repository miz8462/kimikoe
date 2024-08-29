import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomYearPicker extends DatePickerModel {
  CustomYearPicker(
      {required DateTime currentTime,
      required DateTime minTime,
      required DateTime maxTime,
      required LocaleType locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 0, 0]; // 年のみ表示
  }

  @override
  DateTime finalTime() {
    return DateTime(currentTime.year);
  }
}
