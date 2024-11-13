import 'dart:io';

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
  String? officialUrl,
  String? twitterUrl,
  String? instagramUrl,
  String? comment,
}) async {
  await supabase.from(TableName.idolGroups.name).insert({
    ColumnName.cName.name: name,
    ColumnName.imageUrl.name: imageUrl,
    ColumnName.yearFormingGroups.name: year == null ? null : int.tryParse(year),
    ColumnName.officialUrl.name: officialUrl,
    ColumnName.twitterUrl.name: twitterUrl,
    ColumnName.instagramUrl.name: instagramUrl,
    ColumnName.comment.name: comment,
  });
}

Future<void> insertIdolData({
  required String name,
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
  await supabase.from(TableName.idol.name).insert({
    ColumnName.cName.name: name,
    ColumnName.groupId.name: groupId,
    ColumnName.color.name: color,
    ColumnName.imageUrl.name: imageUrl,
    ColumnName.birthday.name: birthday,
    ColumnName.birthYear.name: birthYear,
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
  String? imageUrl,
  String? releaseDate,
  int? lyricistId,
  int? composerId,
  String? comment,
}) async {
  await supabase.from(TableName.songs.name).insert({
    ColumnName.title.name: name,
    ColumnName.lyrics.name: lyric,
    ColumnName.groupId.name: groupId,
    ColumnName.imageUrl.name: imageUrl,
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

String? fetchImageUrl(String imagePath) {
  return supabase.storage.from(TableName.images.name).getPublicUrl(imagePath);
}

Future<List<Map<String, dynamic>>> fetchIdAndNameList(String tableName) async {
  return await supabase
      .from(tableName)
      .select('${ColumnName.id.name}, ${ColumnName.cName.name}');
}

int fetchSelectedDataIdFromName({
  required List<Map<String, dynamic>> list,
  required String? name,
}) {
  final selectedDataList =
      list.where((item) => item[ColumnName.cName.name] == name).toList();
  if (selectedDataList.isEmpty) {
    throw StateError('No element found for the given name: $name');
  }
  final selectedData = selectedDataList.single;
  final selectedDataId = selectedData[ColumnName.id.name];
  return selectedDataId;
}

Future<List<Map<String, dynamic>>> fetchArtists() async {
  return await supabase.from(TableName.artists.name).select();
}

Future<Map<String, dynamic>> fetchArtistById(String id) async {
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
  String? officialUrl,
  String? twitterUrl,
  String? instagramUrl,
  String? comment,
  required String id,
}) async {
  await supabase.from(TableName.idolGroups.name).update({
    ColumnName.cName.name: name,
    ColumnName.imageUrl.name: imageUrl,
    ColumnName.yearFormingGroups.name: year == null ? null : int.tryParse(year),
    ColumnName.officialUrl.name: officialUrl,
    ColumnName.twitterUrl.name: twitterUrl,
    ColumnName.instagramUrl.name: instagramUrl,
    ColumnName.comment.name: comment,
  }).eq(ColumnName.id.name, id);
}

Future<void> updateIdol({
  required String name,
  int? groupId,
  String? color,
  String? imageUrl,
  String? birthday,
  int? birthYear,
  int? height,
  String? hometown,
  int? debutYear,
  String? comment,
  required int id,
}) async {
  await supabase.from(TableName.idol.name).update({
    ColumnName.cName.name: name,
    ColumnName.groupId.name: groupId,
    ColumnName.color.name: color,
    ColumnName.imageUrl.name: imageUrl,
    ColumnName.birthday.name: birthday,
    ColumnName.birthYear.name: birthYear,
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
  String? imageUrl,
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
    ColumnName.imageUrl.name: imageUrl,
    ColumnName.releaseDate.name: releaseDate,
    ColumnName.lyricistId.name: lyricistId,
    ColumnName.composerId.name: composerId,
    ColumnName.comment.name: comment,
  }).eq(ColumnName.id.name, id);
}

Future<void> updateUser({
  required String name,
  required String email,
  required String imageUrl,
  String? comment,
  required String id,
}) async {
  await supabase.from(TableName.profiles.name).update({
    ColumnName.cName.name: name,
    ColumnName.email.name: email,
    ColumnName.imageUrl.name: imageUrl,
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
