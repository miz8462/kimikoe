import 'package:flutter/material.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> insertArtistData({
  required String name,
  required BuildContext context,
  required SupabaseClient supabase,
  String? imageUrl,
  String? comment,
}) async {
  try {
    await supabase.from(TableName.artists).insert({
      ColumnName.name: name,
      ColumnName.imageUrl: imageUrl,
      ColumnName.comment: comment,
    });

    if (!context.mounted) return;
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: 'アーティストを登録しました: $name',
    );
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: 'アーティストの登録中にエラーが発生しました: $name',
      isError: true,
    );
    rethrow;
  }
}

Future<void> insertIdolGroupData({
  required String name,
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
    await supabase.from(TableName.idolGroups).insert({
      ColumnName.name: name,
      ColumnName.imageUrl: imageUrl,
      ColumnName.yearFormingGroups: year == null ? null : int.tryParse(year),
      ColumnName.officialUrl: officialUrl,
      ColumnName.twitterUrl: twitterUrl,
      ColumnName.instagramUrl: instagramUrl,
      ColumnName.scheduleUrl: scheduleUrl,
      ColumnName.comment: comment,
    });
    if (!context.mounted) return;
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: 'グループを登録しました: $name',
    );
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: 'グループの登録中にエラーが発生しました: $name',
      isError: true,
    );
    rethrow;
  }
}

Future<void> insertIdolData({
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
    await supabase.from(TableName.idols).insert({
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
    });
    if (!context.mounted) return;
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: 'アイドルを登録しました: $name',
    );
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: 'アイドルの登録中にエラーが発生しました: $name',
      isError: true,
    );
    rethrow;
  }
}

Future<void> insertSongData({
  required String title,
  required String lyric,
  required BuildContext context,
  required SupabaseClient supabase,
  int? groupId,
  String? imageUrl,
  String? releaseDate,
  int? lyricistId,
  int? composerId,
  String? comment,
}) async {
  try {
    await supabase.from(TableName.songs).insert({
      ColumnName.title: title,
      ColumnName.lyrics: lyric,
      ColumnName.groupId: groupId,
      ColumnName.imageUrl: imageUrl,
      ColumnName.releaseDate: releaseDate,
      ColumnName.lyricistId: lyricistId,
      ColumnName.composerId: composerId,
      ColumnName.comment: comment,
    });
    if (!context.mounted) return;
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: '曲を登録しました: $title',
    );
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: '曲の登録中にエラーが発生しました: $title',
      isError: true,
    );
    rethrow;
  }
}
