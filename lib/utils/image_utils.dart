import 'dart:io';

import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/utils/generate_simple_random_string.dart';

// e.g. /aaa/bbb/ccc/image.png
// nullが入力されたらnullを返す
// File型のimage、String型のimageUrlが入力された場合
// 20文字のランダム文字列+jpgを返す
String? createImageNameWithJPG({File? image, String? imageUrl}) {
  if (image == null && imageUrl == null) {
    return null;
  }
  return '${generateSimpleRandomString(20)}.jpg';
}

String? getImagePath({
  bool? isEditing = false,
  bool isImageChanged = false,
  String? imageUrl,
  File? imageFile,
}) {
  if (isEditing! && !isImageChanged) {
    return createImageNameWithJPG(imageUrl: imageUrl);
  } else {
    if (imageFile == null) {
      return noImage;
    } else {
      return createImageNameWithJPG(image: imageFile);
    }
  }
}
