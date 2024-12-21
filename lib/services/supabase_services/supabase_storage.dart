import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> uploadImageToStorage({
  required String table,
  required String path,
  required File file,
  required BuildContext context,
  SupabaseClient? supabaseClient,
}) async {
  final client = supabaseClient ?? supabase;
  try {
    await client.storage.from(table).upload(path, file);
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

// HACK: Supabase CLI でできるらしいよ
String fetchImageUrl(
  String imagePath, {
  required Logger logger,
  SupabaseClient? injectedSupabase,
}) {
  // XXX: ｲｼﾞﾙﾅｷｹﾝ
  final diSupabase = injectedSupabase ?? supabase;
  if (imagePath == noImage) return noImage;
  try {
    final url =
        diSupabase.storage.from(TableName.images).getPublicUrl(imagePath);
    logger.i('画像URLを取得しました');
    return url;
  } catch (e) {
    logger.e('画像URLの取得中にエラーが発生しました', error: e);
    return noImage;
  }
}
