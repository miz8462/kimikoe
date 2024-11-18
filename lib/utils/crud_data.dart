import 'dart:io';

import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// CREATE
Future<void> insertArtistData({
  required String name,
  String? imageUrl,
  String? comment,
}) async {
  await supabase.from(TableName.artists).insert({
    ColumnName.name: name,
    ColumnName.imageUrl: imageUrl,
    ColumnName.comment: comment,
  });
}

Future<void> insertIdolGroupData({
  required String name,
  String? imageUrl,
  String? year,
  String? officialUrl,
  String? twitterUrl,
  String? instagramUrl,
  String? scheduleUrl,
  String? comment,
}) async {
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
  await supabase.from(TableName.idol).insert({
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
  await supabase.from(TableName.songs).insert({
    ColumnName.title: name,
    ColumnName.lyrics: lyric,
    ColumnName.groupId: groupId,
    ColumnName.imageUrl: imageUrl,
    ColumnName.releaseDate: releaseDate,
    ColumnName.lyricistId: lyricistId,
    ColumnName.composerId: composerId,
    ColumnName.comment: comment,
  });
}

Future<void> uploadImageToStorage({
  required String table,
  required String path,
  required File file,
}) async {
  try {
    await supabase.storage.from(TableName.images).upload(path, file);
  } catch (e) {
    if (e is StorageException) {
      print('Storage error: ${e.message}');
    } else if (e is SocketException) {
      print('Network error: ${e.message}');
    } else if (e is HttpException) {
      print('HTTP error: ${e.message}');
    } else {
      print('Error: $e');
    }
  }
}

// READ
Future<List<Map<String, dynamic>>> fetchGroupMembers(int groupId) async {
  return await supabase
      .from(TableName.idol)
      .select()
      .eq(ColumnName.groupId, groupId);
}

Future fetchCurrentUserInfo() {
  final currentUserId = supabase.auth.currentUser!.id;
  final userInfo = supabase
      .from(TableName.profiles)
      .select()
      .eq(ColumnName.id, currentUserId);
  return userInfo;
}

String? fetchImageUrl(String imagePath) {
  return supabase.storage.from(TableName.images).getPublicUrl(imagePath);
}

Future<List<Map<String, dynamic>>> fetchIdAndNameList(String tableName) async {
  return await supabase
      .from(tableName)
      .select('${ColumnName.id}, ${ColumnName.name}');
}

int fetchSelectedDataIdFromName({
  required List<Map<String, dynamic>> list,
  required String? name,
}) {
  final selectedDataList =
      list.where((item) => item[ColumnName.name] == name).toList();
  if (selectedDataList.isEmpty) {
    throw StateError('No element found for the given name: $name');
  }
  final selectedData = selectedDataList.single;
  final selectedDataId = selectedData[ColumnName.id];
  return selectedDataId;
}

Future<List<Map<String, dynamic>>> fetchArtists() async {
  return await supabase.from(TableName.artists).select();
}

Future<Map<String, dynamic>> fetchArtistById(String id) async {
  return await supabase
      .from(TableName.artists)
      .select()
      .eq(ColumnName.id, id)
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
  String? scheduleUrl,
  String? comment,
  required String id,
}) async {
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
  await supabase.from(TableName.idol).update({
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
  await supabase.from(TableName.songs).update({
    ColumnName.title: name,
    ColumnName.lyrics: lyric,
    ColumnName.groupId: groupId,
    ColumnName.imageUrl: imageUrl,
    ColumnName.releaseDate: releaseDate,
    ColumnName.lyricistId: lyricistId,
    ColumnName.composerId: composerId,
    ColumnName.comment: comment,
  }).eq(ColumnName.id, id);
}

Future<void> updateUser({
  required String name,
  required String email,
  required String imageUrl,
  String? comment,
  required String id,
}) async {
  await supabase.from(TableName.profiles).update({
    ColumnName.name: name,
    ColumnName.email: email,
    ColumnName.imageUrl: imageUrl,
    ColumnName.comment: comment,
  }).eq(
    ColumnName.id,
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
