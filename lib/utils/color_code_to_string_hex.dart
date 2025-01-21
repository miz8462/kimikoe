import 'package:flutter/material.dart';

String toHex(double value) {
  return value.toInt().toRadixString(16).padLeft(2, '0');
}

String colorCodeToStringHex(Color color) {
  final red = toHex(color.r * 255);
  final green = toHex(color.g * 255);
  final blue = toHex(color.b * 255);
  final alpha = toHex(color.a * 255);
  final hex = '0x$alpha$red$green$blue';
  return hex;
}
