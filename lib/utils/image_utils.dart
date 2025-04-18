import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_storage.dart';
import 'package:kimikoe_app/utils/generate_simple_random_string.dart';

// 画像選択していない場合はnoImageを返す
// その他は20文字のランダム文字列+jpgを返す
String createImagePath({
  File? imageFile,
}) {
  if (imageFile == null) {
    return noImage;
  } else {
    return '${generateSimpleRandomString(20)}.jpg';
  }
}

// TODO: test
Future<String?> processImage({
  required bool isEditing,
  required bool isImageChanged,
  required String existingImageUrl,
  required File? selectedImage,
  required BuildContext context,
  required SupabaseStorage storage,
  String Function({File? imageFile})? createImagePathFunction = createImagePath,
  UploadImageToStorage? uploadFunction,
  String Function(
    String imagePath,
  )? fetchFunction,
}) async {
  // uploadFunction と fetchFunction が null の場合は supabaseStorage のメソッドを使用

  uploadFunction ??= storage.uploadImageToStorage;
  fetchFunction ??= storage.fetchImageUrl;

  // 新規作成モードで画像変更なし
  if (!isEditing && !isImageChanged) {
    return noImage;
  }

  // 編集モードで画像変更なし
  if (isEditing && !isImageChanged) {
    return existingImageUrl;
  } else {
    final imagePath = createImagePathFunction!(
      imageFile: selectedImage,
    );
    // 新規の場合、編集で画像を変更した場合は登録する
    if (selectedImage != null) {
      await uploadFunction(
        path: imagePath,
        file: selectedImage,
        context: context,
      );
    }
    return fetchFunction(
      imagePath,
    );
  }
}

typedef UploadImageToStorage = Future<void> Function({
  required String path,
  required File file,
  required BuildContext context,
});
