import 'package:intl/intl.dart';

String formatDateTimeToXXXX({
  required DateTime date,
  required String formatStyle,
}) {
  final formatter = DateFormat(formatStyle);
  return formatter.format(date);
}
