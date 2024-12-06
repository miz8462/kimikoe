import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/utils/generate_simple_random_string.dart';

void main() {
  group('generateSimplerandomString関数のテスト', () {
    test('毎回異なる文字列を生成する', () {
      final length = 10;
      final randomString1 = generateSimpleRandomString(length);
      final randomString2 = generateSimpleRandomString(length);
      expect(randomString1, isNot(equals(randomString2)));
    });
    test('生成された文字列が指定された文字セットからのみ文字を含む', () {
      final length = 10;
      final randomString = generateSimpleRandomString(length);
      const chars =
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      for (final char in randomString.split('')) {
        expect(chars.contains(char), isTrue);
      }
    });
  });
}
