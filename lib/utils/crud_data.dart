import 'dart:io';

import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';

// CREATE
Future<void> insertArtistData({
  required String name,
  required String imageUrl,
  required String comment,
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

Future<void> uploadImageToStorage({
  required String table,
  required String path,
  required File file,
}) async {
  await supabase.storage.from(TableName.images.name).upload(path, file);
}

// READ
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

Stream fetchDatabyStream({
  required String table,
  required String id,
}) {
  return supabase.from(table).stream(primaryKey: [id]);
}

Future fetchGroupMemberbyStream({
  required String table,
  required String column,
  required int id,
}) async {
  return await supabase.from(table).select().eq(column, id);
}

// UPDATE
Future<void> updateIdolGroup({
  required String name,
  String? imageUrl,
  String? year,
  String? comment,
  required String groupId,
}) async {
  await supabase.from(TableName.idolGroups.name).update({
    ColumnName.cName.name: name,
    ColumnName.imageUrl.name: imageUrl,
    ColumnName.yearFormingGroups.name: year == null ? null : int.tryParse(year),
    ColumnName.comment.name: comment,
  }).eq(ColumnName.id.name, groupId);
}

// DELETE
Future<void> deleteDataFromTable({
  required String table,
  required String column,
  required String value,
}) async {
  await supabase.from(table).delete().eq(column, value);
}
