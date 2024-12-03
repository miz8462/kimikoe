import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/utils/color_code_to_string_hex.dart';

void main() {
  test('ARGB formatの色をStringにする', () {
    final color = Colors.green;

    final expected = '0xff4caf50';

    final result = colorCodeToStringHex(color);
    expect(result, expected);
  });
}
