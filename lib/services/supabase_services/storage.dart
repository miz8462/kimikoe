import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Storage {
  Storage(this.client);
  final SupabaseClient client;
  Future<void> uploadImageToStorage({
    required String path,
    required File file,
    required BuildContext context,
  }) async {
    try {
      await client.storage.from(TableName.images).upload(path, file);
      if (!context.mounted) return;
      showLogAndSnackBar(
        context: context,
        message: '画像をストレージにアップロードしました',
      );
    } catch (e) {
      logger.e('画像をストレージにアップロード中にエラーが発生しました', error: e);
      rethrow;
    }
  }

  String fetchImageUrl(String imagePath) {
    if (imagePath == noImage) return noImage;
    try {
      final url = client.storage.from(TableName.images).getPublicUrl(imagePath);
      logger.i('画像URLを取得しました');
      return url;
    } catch (e) {
      logger.e('画像URLの取得中にエラーが発生しました', error: e);
      return noImage;
    }
  }

  Future<void> deleteImageFromStorage(
    String imagePath,
    BuildContext context,
  ) async {
    try {
      await client.storage.from(TableName.images).remove([imagePath]);
      if (!context.mounted) return;
      showLogAndSnackBar(
        context: context,
        message: '画像をストレージから削除しました',
      );
    } catch (e) {
      logger.e('画像をストレージから削除中にエラーが発生しました', error: e);
      rethrow;
    }
  }
}
