import 'dart:io';

// e.g. /aaa/bbb/ccc/image.png
String? createImageNameWithJPG(File? image) {
  if (image == null) {
    return null;
  }
  final imagePath = image.path.split('/').last.split('.').first;
  final imagePathWithCreatedAtJPG =
      '$imagePath${(DateTime.now().toString()).replaceAll(' ', '-')}.jpg';
  return imagePathWithCreatedAtJPG;
}
