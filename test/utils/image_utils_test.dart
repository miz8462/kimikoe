import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/utils/image_utils.dart';

void main() {
  group('createImageNameWithJPG関数', () {
    // nullが入力されたらnullを返す
    test('nullの場合', () {
      final result = createImageNameWithJPG();
      expect(result, isNull);
    });
    // File型のimage、String型のimageUrlが入力された場合
    // 20文字のランダム文字列+jpgを返す
    test('File型のimageが入力された場合', () {
      final image = File('path/to/image.jpg');
      final result = createImageNameWithJPG(image: image);
      expect(result, matches(RegExp(r'^[a-zA-Z0-9]{20}\.jpg$')));
    });
    test('String型のimageUrlが入力された場合', () {
      final imageUrl = 'https://example.com/image.png';
      final result = createImageNameWithJPG(imageUrl: imageUrl);
      expect(result, matches(RegExp(r'^[a-zA-Z0-9]{20}\.jpg$')));
    });
  });
  group('getImagePath関数', () {
    test(
        'isEditing trueかつ isImageChangedがfalseの場合、20文字のランダムな文字列に.jpgを追加したものを返す',
        () {
      final result = getImagePath(
          isEditing: true,
          isImageChanged: false,
          imageUrl: 'https://example.com/image.png');
      expect(result, matches(RegExp(r'^[a-zA-Z0-9]{20}\.jpg$')));
    });
    test('isEditing falseでimageFileがnullの場合、noImageを返す', () {
      final result = getImagePath(
        isEditing: false,
        isImageChanged: true,
        imageUrl: null,
      );
      expect(result, equals(noImage));
    });
    test('imageFileが与えられた場合、20文字のランダムな文字列に.jpgを追加したものを返す', () {
      final imageFile = File('path/to/image.jpg');
      final result = getImagePath(
        isEditing: false,
        isImageChanged: true,
        imageFile: imageFile,
      );
      expect(result, matches(RegExp(r'^[a-zA-Z0-9]{20}\.jpg$')));
    });
  });
}
