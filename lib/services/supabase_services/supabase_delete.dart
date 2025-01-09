import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> deleteDataById({
  required String table,
  required String id,
  required BuildContext context,
  required SupabaseClient supabase,
}) async {
  try {
    final response =
        await supabase.from(table).delete().eq(ColumnName.id, id);
    logger.d(response.toString());

    if (!context.mounted) return;
    showLogAndSnackBar(
      context: context,
      message: 'データを削除しました。ID: $id',
    );
    logger.i('データを削除しました。ID: $id');
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      message: 'データの削除中にエラーが発生しました。ID: $id',
      isError: true,
    );
    logger.e('データの削除中にエラーが発生しました。ID: $id', error: e);
    rethrow;
  }
}
