import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDelete {
  Future<void> deleteDataById({
    required String table,
    required String id,
    required BuildContext context,
    required SupabaseClient supabase,
  }) async {
    try {
      await supabase.from(table).delete().eq(ColumnName.id, id);

      if (context.mounted) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          showLogAndSnackBar(
            context: context,
            message: 'データを削除しました。ID: $id',
          );
        });
        logger.i('データを削除しました。ID: $id');
      }
    } catch (e) {
      if (context.mounted) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          showLogAndSnackBar(
            context: context,
            message: 'データの削除中にエラーが発生しました。ID: $id',
            isError: true,
          );
        });
        logger.e('データの削除中にエラーが発生しました。ID: $id', error: e);
        rethrow;
      }
    }
  }

  Future<void> deleteDataByName({
    required String table,
    required String name,
    String targetColumn = ColumnName.name,
  }) async {
    try {
      await supabase.from(table).delete().eq(targetColumn, name);

      logger.i('$nameのデータを削除しました');
    } catch (e) {
      logger.e('$nameの削除中にエラーが発生しました', error: e);
      rethrow;
    }
  }
}
