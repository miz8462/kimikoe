import 'dart:io';

import 'package:kimikoe_app/config/config.dart';

// e.g. /aaa/bbb/ccc/image.png
String? createImageNameWithJPG({File? image, String? imageUrl}) {
  if (image == null && imageUrl == null) {
    return null;
  }
  late String imagePathWithCreatedAtJPG;

  if (image != null) {
    final imagePath = image.path.split('/').last.split('.').first;
    imagePathWithCreatedAtJPG =
        '$imagePath${(DateTime.now().toString()).replaceAll(' ', '-')}.jpg';
  } else {
    imagePathWithCreatedAtJPG = imageUrl!.split('/').last;
  }

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
      return defaultPathNoImage;
    } else {
      return createImageNameWithJPG(image: imageFile);
    }
  }
}
