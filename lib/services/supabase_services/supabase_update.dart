// UPDATE
import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUpdate {
  Future<void> updateIdolGroup({
    required String name,
    required String id,
    required BuildContext context,
    required SupabaseClient supabase,
    String? imageUrl,
    String? year,
    String? officialUrl,
    String? twitterUrl,
    String? instagramUrl,
    String? scheduleUrl,
    String? comment,
  }) async {
    try {
      await supabase.from(TableName.idolGroups).update({
        ColumnName.name: name,
        ColumnName.imageUrl: imageUrl,
        ColumnName.yearFormingGroups: year == null ? null : int.tryParse(year),
        ColumnName.officialUrl: officialUrl,
        ColumnName.twitterUrl: twitterUrl,
        ColumnName.instagramUrl: instagramUrl,
        ColumnName.scheduleUrl: scheduleUrl,
        ColumnName.comment: comment,
      }).eq(ColumnName.id, id);
      if (!context.mounted) return;
      showLogAndSnackBar(
        context: context,
        message: 'グループを更新しました。グループ名: $name',
      );
    } catch (e) {
      showLogAndSnackBar(
        context: context,
        message: 'グループの更新中にエラーが発生しました。グループ名: $name',
        isError: true,
      );
      rethrow;
    }
  }

  Future<void> updateIdol({
    required int id,
    required String name,
    required BuildContext context,
    required SupabaseClient supabase,
    int? groupId,
    String? color,
    String? imageUrl,
    String? birthday,
    int? birthYear,
    int? height,
    String? hometown,
    int? debutYear,
    String? comment,
  }) async {
    try {
      await supabase.from(TableName.idols).update({
        ColumnName.name: name,
        ColumnName.groupId: groupId,
        ColumnName.color: color,
        ColumnName.imageUrl: imageUrl,
        ColumnName.birthday: birthday,
        ColumnName.birthYear: birthYear,
        ColumnName.height: height,
        ColumnName.hometown: hometown,
        ColumnName.debutYear: debutYear,
        ColumnName.comment: comment,
      }).eq(ColumnName.id, id);
      if (!context.mounted) return;
      showLogAndSnackBar(
        context: context,
        message: 'アイドルデータを更新しました。グループ名: $name',
      );
    } catch (e) {
      showLogAndSnackBar(
        context: context,
        message: 'アイドルデータの更新中にエラーが発生しました。アイドル名: $name',
        isError: true,
      );
      logger.e('データの更新中にエラーが発生しました。アイドル名: $name', error: e);
      rethrow;
    }
  }

  Future<void> updateSong({
    required int id,
    required String title,
    required String lyric,
    required BuildContext context,
    required SupabaseClient supabase,
    int? groupId,
    String? movieUrl,
    String? imageUrl,
    String? releaseDate,
    int? lyricistId,
    int? composerId,
    String? comment,
  }) async {
    try {
      await supabase.from(TableName.songs).update({
        ColumnName.title: title,
        ColumnName.movieUrl: movieUrl,
        ColumnName.lyrics: lyric,
        ColumnName.groupId: groupId,
        ColumnName.imageUrl: imageUrl,
        ColumnName.releaseDate: releaseDate,
        ColumnName.lyricistId: lyricistId,
        ColumnName.composerId: composerId,
        ColumnName.comment: comment,
      }).eq(ColumnName.id, id);
      if (!context.mounted) return;
      showLogAndSnackBar(
        context: context,
        message: '曲を更新しました。曲名: $title',
      );
    } catch (e) {
      showLogAndSnackBar(
        context: context,
        message: '曲の更新中にエラーが発生しました。曲名: $title',
        isError: true,
      );
      rethrow;
    }
  }

  Future<void> updateUser({
    required String id,
    required String name,
    required String email,
    required String imageUrl,
    required BuildContext context,
    required SupabaseClient supabase,
    String? comment,
  }) async {
    try {
      await supabase.from(TableName.profiles).update({
        ColumnName.name: name,
        ColumnName.email: email,
        ColumnName.imageUrl: imageUrl,
        ColumnName.comment: comment,
      }).eq(ColumnName.id, id);
      if (!context.mounted) return;
      showLogAndSnackBar(
        context: context,
        message: 'ユーザー情報を更新しました',
      );
    } catch (e) {
      showLogAndSnackBar(
        context: context,
        message: 'ユーザー情報の更新中にエラーが発生しました',
        isError: true,
      );
      rethrow;
    }
  }
}
