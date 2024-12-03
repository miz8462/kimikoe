import 'dart:io';
import 'dart:math';

import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/utils/generate_simple_random_string.dart';

// e.g. /aaa/bbb/ccc/image.png
String? createImageNameWithJPG({File? image, String? imageUrl}) {
  if (image == null && imageUrl == null) {
    return null;
  }
  late String imagePathWithCreatedAtJPG;
  imagePathWithCreatedAtJPG = '${generateSimpleRandomString(20)}.jpg';

  return imagePathWithCreatedAtJPG;
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
