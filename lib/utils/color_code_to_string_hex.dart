import 'package:flutter/material.dart';

String colorCodeToStringHex(Color color) {
  return '0x${color.value.toRadixString(16)}';
}
