import 'package:intl/intl.dart';

String formatDateTimeToXXXX({
  required DateTime date,
  required String formatStyle,
}) {
  final formatter = DateFormat(formatStyle);
  return formatter.format(date);
}

String formatStringDateToJapanese(String date) {
  final birthDay = DateTime.parse(date);
  DateFormat formatter = DateFormat("yyyy年MM月dd日");
  return formatter.format(birthDay);
}
