import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTimeToXXXX({
  required DateTime date,
  required String formatStyle,
}) {
  final formatter = DateFormat(formatStyle);
  return formatter.format(date);
}

String formatStringDateToJapaneseOnlyMonthAndDay(String strDate) {
  final date = DateTime.parse(strDate);
  DateFormat formatter = DateFormat("MM月dd日");
  return formatter.format(date);
}

String formatStringDateToJapaneseWithYear(String strDate) {
  final date = DateTime.parse(strDate);
  DateFormat formatter = DateFormat("yyyy年MM月dd日");
  return formatter.format(date);
}

String formatStringDateToMMdd(String strDate) {
  final date = DateTime.parse(strDate);
  DateFormat formatter = DateFormat("MM-dd");
  return formatter.format(date);
}

String formatStringDateToSlash(String date) {
  final birthDay = DateTime.parse(date);
  DateFormat formatter = DateFormat("yyyy/MM/dd");
  return formatter.format(birthDay);
}


