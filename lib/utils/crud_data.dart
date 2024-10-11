import 'dart:io';

import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';

// CREATE
Future<void> insertArtistData({
  required String name,
  String? imageUrl,
  String? comment,
}) async {
  await supabase.from(TableName.artists.name).insert({
    ColumnName.cName.name: name,
    ColumnName.imageUrl.name: imageUrl,
    ColumnName.comment.name: comment,
  });
}

Future<void> insertIdolGroupData({
  required String name,
  String? imageUrl,
  String? year,
  String? comment,
}) async {
  await supabase.from(TableName.idolGroups.name).insert({
    ColumnName.cName.name: name,
    ColumnName.imageUrl.name: imageUrl,
    ColumnName.yearFormingGroups.name: year == null ? null : int.tryParse(year),
    ColumnName.comment.name: comment,
  });
}

Future<void> insertIdolData({
  required String name,
  int? groupId,
  String? color,
  String? imagePath,
  String? birthday,
  String? height,
  String? hometown,
  String? debutYear,
  String? comment,
}) async {
  await supabase.from(TableName.idol.name).insert({
    ColumnName.cName.name: name,
    ColumnName.groupId.name: groupId,
    ColumnName.color.name: color,
    ColumnName.imageUrl.name: imagePath,
    ColumnName.birthday.name: birthday,
    ColumnName.height.name: height,
    ColumnName.hometown.name: hometown,
    ColumnName.debutYear.name: debutYear,
    ColumnName.comment.name: comment,
  });
}

Future<void> insertSongData({
  required String name,
  required String lyric,
  int? groupId,
  String? imagePath,
  String? releaseDate,
  int? lyricistId,
  int? composerId,
  String? comment,
}) async {
  await supabase.from(TableName.songs.name).insert({
    ColumnName.title.name: name,
    ColumnName.lyrics.name: lyric,
    ColumnName.groupId.name: groupId,
    ColumnName.imageUrl.name: imagePath,
    ColumnName.releaseDate.name: releaseDate,
    ColumnName.lyricistId.name: lyricistId,
    ColumnName.composerId.name: composerId,
    ColumnName.comment.name: comment,
  });
}

Future<void> uploadImageToStorage({
  required String table,
  required String path,
  required File file,
}) async {
  await supabase.storage.from(TableName.images.name).upload(path, file);
}

// READ
Future<List<Map<String, dynamic>>> fetchGroupMembers(int groupId) async {
  return await supabase
      .from(TableName.idol.name)
      .select()
      .eq(ColumnName.groupId.name, groupId);
}

Future fetchCurrentUserInfo() {
  final currentUserId = supabase.auth.currentUser!.id;
  final userInfo = supabase
      .from(TableName.profiles.name)
      .select()
      .eq(ColumnName.id.name, currentUserId);
  return userInfo;
}

String fetchImageOfNoImage() {
  return supabase.storage.from(TableName.images.name).getPublicUrl(noImage);
}

String fetchPublicImageUrl(String imageUrl) {
  return supabase.storage.from(TableName.images.name).getPublicUrl(imageUrl);
}

Future<List<Map<String, dynamic>>> fetchIdAndNameList(String tableName) async {
  return await supabase
      .from(tableName)
      .select('${ColumnName.id.name}, ${ColumnName.cName.name}');
}

int fetchSelectedDataIdFromName({
  required List<Map<String, dynamic>> list,
  required String name,
}) {
  final selectedData =
      list.where((item) => item[ColumnName.cName.name] == name).single;
  final selectedDataId = selectedData[ColumnName.id.name];
  return selectedDataId;
}

Future<Map<String, dynamic>> fetchComposer(String id) async {
  return await supabase
      .from(TableName.artists.name)
      .select()
      .eq(ColumnName.id.name, id)
      .single();
}

Stream fetchDatabyStream({
  required String table,
  required String id,
}) {
  return supabase.from(table).stream(primaryKey: [id]);
}

// UPDATE
Future<void> updateIdolGroup({
  required String name,
  String? imageUrl,
  String? year,
  String? comment,
  required String id,
}) async {
  await supabase.from(TableName.idolGroups.name).update({
    ColumnName.cName.name: name,
    ColumnName.imageUrl.name: imageUrl,
    ColumnName.yearFormingGroups.name: year == null ? null : int.tryParse(year),
    ColumnName.comment.name: comment,
  }).eq(ColumnName.id.name, id);
}

Future<void> updateIdol({
  required String name,
  int? groupId,
  String? color,
  String? imagePath,
  String? birthday,
  String? height,
  String? hometown,
  String? debutYear,
  String? comment,
  required int id,
}) async {
  await supabase.from(TableName.idol.name).update({
    ColumnName.cName.name: name,
    ColumnName.groupId.name: groupId,
    ColumnName.color.name: color,
    ColumnName.imageUrl.name: imagePath,
    ColumnName.birthday.name: birthday,
    ColumnName.height.name: height,
    ColumnName.hometown.name: hometown,
    ColumnName.debutYear.name: debutYear,
    ColumnName.comment.name: comment,
  }).eq(ColumnName.id.name, id);
}

Future<void> updateSong({
  required String name,
  required String lyric,
  int? groupId,
  String? imagePath,
  String? releaseDate,
  int? lyricistId,
  int? composerId,
  String? comment,
  required int id,
}) async {
  await supabase.from(TableName.songs.name).update({
    ColumnName.title.name: name,
    ColumnName.lyrics.name: lyric,
    ColumnName.groupId.name: groupId,
    ColumnName.imageUrl.name: imagePath,
    ColumnName.releaseDate.name: releaseDate,
    ColumnName.lyricistId.name: lyricistId,
    ColumnName.composerId.name: composerId,
    ColumnName.comment.name: comment,
  }).eq(ColumnName.id.name, id);
}

Future<void> updateUser({
  required String name,
  required String email,
  String? comment,
  required String id,
}) async {
  await supabase.from(TableName.profiles.name).update({
    ColumnName.cName.name: name,
    ColumnName.email.name: email,
    // ColumnName.imageUrl.name: imageUrl,
    ColumnName.comment.name: comment,
  }).eq(
    ColumnName.id.name,
    id,
  );
}

// DELETE
Future<void> deleteDataFromTable({
  required String table,
  required String column,
  required String value,
}) async {
  await supabase.from(table).delete().eq(column, value);
}
