import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTimeToXXXX({
  required DateTime date,
  required String formatStyle,
}) {
  final formatter = DateFormat(formatStyle);
  return formatter.format(date);
}

String formatStringDateToJapaneseOnlyMonthAndDay(String date) {
  final birthDay = DateTime.parse(date);
  DateFormat formatter = DateFormat("MM月dd日");
  return formatter.format(birthDay);
}

String formatStringDateToJapaneseWithYear(String date) {
  final birthDay = DateTime.parse(date);
  DateFormat formatter = DateFormat("yyyy年MM月dd日");
  return formatter.format(birthDay);
}

String formatStringDateToMMdd(String date) {
  final birthDay = DateTime.parse(date);
  DateFormat formatter = DateFormat("MM-dd");
  return formatter.format(birthDay);
}

String formatStringDateToSlash(String date) {
  final birthDay = DateTime.parse(date);
  DateFormat formatter = DateFormat("yyyy/MM/dd");
  return formatter.format(birthDay);
}

String formatStringColorCode(Color color) {
  return '0x${color.value.toRadixString(16)}';
}
