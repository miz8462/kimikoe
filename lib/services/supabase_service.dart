import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/artist.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/utils/show_log_and_snack_bar.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// CREATE
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
      logger: logger,
      message: '画像をストレージにアップロードしました',
    );
  } catch (e) {
    logger.e('画像をストレージにアップロード中にエラーが発生しました', error: e);
    rethrow;
  }
}

// READ
Future<List<Map<String, dynamic>>> fetchArtists({
  required SupabaseClient supabase,
  Logger? injectedlogger,
}) async {
  final dilogger = injectedlogger ?? logger;
  try {
    final response = await supabase.from(TableName.artists).select();
    dilogger.i('アーティストのリストを取得しました');
    return response;
  } catch (e) {
    dilogger.e('アーティストのリストの取得中にエラーが発生しました', error: e);
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> fetchGroupMembers(
  int groupId, {
  required SupabaseClient supabase,
  Logger? injectedlogger,
}) async {
  final dilogger = injectedlogger ?? logger;

  try {
    final response = await supabase
        .from(TableName.idols)
        .select()
        .eq(ColumnName.groupId, groupId);
    dilogger.i('グループメンバーリストを取得しました');
    return response;
  } catch (e) {
    dilogger.e('グループメンバーリストの取得中にエラーが発生しました', error: e);
    rethrow;
  }
}

// HACK: Supabase CLI でできるらしいよ
String fetchImageUrl(
  String imagePath, {
  SupabaseClient? supabaseClient,
  Logger? injectedlogger,
}) {
  final diSupabase = supabaseClient ?? supabase;
  final dilogger = injectedlogger ?? logger;
  if (imagePath == noImage) return noImage;
  try {
    final url =
        diSupabase.storage.from(TableName.images).getPublicUrl(imagePath);
    dilogger.i('画像URLを取得しました');
    return url;
  } catch (e) {
    dilogger.e('画像URLの取得中にエラーが発生しました', error: e);
    return noImage;
  }
}

Future<List<Map<String, dynamic>>> fetchIdAndNameList(
  String tableName, {
  required SupabaseClient supabase,
  Logger? injectedlogger,
}) async {
  final dilogger = injectedlogger ?? logger;

  try {
    final response = await supabase
        .from(tableName)
        .select('${ColumnName.id}, ${ColumnName.name}');
    dilogger.i('$tableNameのIDと名前のリストを取得しました');
    return response;
  } catch (e) {
    dilogger.e('$tableNameのIDと名前のリストの取得中にエラーが発生しました', error: e);
    rethrow;
  }
}

Future<List<Artist>> fetchArtistList({
  required SupabaseClient supabase,
  required Logger logger,
}) async {
  try {
    logger.i('Supabaseからアーティストデータを取得中...');
    final response =
        await fetchArtists(supabase: supabase, injectedlogger: logger);
    logger.i('${response.length}件のアーティストデータをSupabaseから取得しました');
    final artists = response.map<Artist>((artist) {
      final imageUrl = fetchImageUrl(
        artist[ColumnName.imageUrl],
        supabaseClient: supabase,
        injectedlogger: logger,
      );
      return Artist(
        id: artist[ColumnName.id],
        name: artist[ColumnName.name],
        imageUrl: imageUrl,
        comment: artist[ColumnName.comment],
      );
    }).toList();

    logger.i('${artists.length}件のアーティストデータをリストにしました');
    return artists;
  } catch (e, stackTrace) {
    logger.e(
      'アーティストリストの取得またはマッピング中にエラーが発生しました',
      error: e,
      stackTrace: stackTrace,
    );
    return [];
  }
}

int fetchSelectedDataIdFromName({
  required List<Map<String, dynamic>> list,
  required String name,
}) {
  final selectedDataList =
      list.where((item) => item[ColumnName.name] == name).toList();
  if (selectedDataList.isEmpty) {
    logger.e('指定された名前: $name に対するデータが見つかりません');
    throw StateError('指定された名前: $name に対するデータが見つかりません');
  }
  final selectedData = selectedDataList.single;
  final selectedDataId = selectedData[ColumnName.id] as int;
  logger.i('指定された名前: $name に対するデータIDを取得しました');
  return selectedDataId;
}

Stream<dynamic> fetchDatabyStream({
  required String table,
  required String id,
  required SupabaseClient supabase,
}) {
  try {
    final stream = supabase.from(table).stream(primaryKey: [id]);
    logger.i('$tableのデータをストリームで取得中...');
    return stream;
  } catch (e) {
    logger.e('$tableのデータをストリームで取得中にエラーが発生しました', error: e);
    rethrow;
  }
}

// UPDATE
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
      logger: logger,
      message: 'グループを更新しました。グループ名: $name',
    );
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      logger: logger,
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
      logger: logger,
      message: 'アイドルデータを更新しました。グループ名: $name',
    );
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      logger: logger,
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
  String? imageUrl,
  String? releaseDate,
  int? lyricistId,
  int? composerId,
  String? comment,
}) async {
  try {
    await supabase.from(TableName.songs).update({
      ColumnName.title: title,
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
      logger: logger,
      message: '曲を更新しました。曲名: $title',
    );
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      logger: logger,
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
      logger: logger,
      message: 'ユーザーを更新しました。ユーザー名: $name',
    );
  } catch (e) {
    showLogAndSnackBar(
      context: context,
      logger: logger,
      message: 'ユーザーの更新中にエラーが発生しました。ユーザー名: $name',
      isError: true,
    );
    rethrow;
  }
}

// DELETE
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
