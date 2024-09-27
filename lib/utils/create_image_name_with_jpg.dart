import 'dart:io';

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
