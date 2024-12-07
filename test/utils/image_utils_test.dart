import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/utils/image_utils.dart';

void main() {
  group('getImagePath関数', () {
    test('画僧を選択していた場合、20文字のランダムな文字列に.jpgを追加したものを返す', () {
      final imageFile = File('path/to/image.jpg');
      final result = getImagePath(
        imageFile: imageFile,
      );
      expect(result, matches(RegExp(r'^[a-zA-Z0-9]{20}\.jpg$')));
    });
    test('画像を選択していない場合はnoImageを返す', () {
      final result = getImagePath();
      expect(result, noImage);
    });
  });
}
