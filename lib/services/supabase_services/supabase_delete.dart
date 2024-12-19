

import 'package:flutter/material.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> deleteDataFromTable({
  required String table,
  required String targetColumn,
  required String targetValue,
  required BuildContext context,
  required SupabaseClient supabase,
}) async {
  try {
    await supabase.from(table).delete().eq(targetColumn, targetValue);
    if (!context.mounted) return;
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: 'データを削除しました。名前: $targetValue',
    );
    logger.i('データを削除しました。名前: $targetValue');
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: 'データの削除中にエラーが発生しました。名前: $targetValue',
      isError: true,
    );
    rethrow;
  }
}
