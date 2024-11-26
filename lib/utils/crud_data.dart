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
  try {
    await supabase.from(TableName.artists).insert({
      ColumnName.name: name,
      ColumnName.imageUrl: imageUrl,
      ColumnName.comment: comment,
    });
    logger.i('アーティストデータを登録しました。アーティスト名: $name');
  } catch (e) {
    logger.e('アーティストデータの登録中にエラーが発生しました。アーティスト名: $name', error: e);
    rethrow;
  }
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
    logger.i('アイドルグループを登録しました。グループ名: $name');
  } catch (e) {
    logger.e('アイドルグループの登録中にエラーが発生しました。グループ名: $name', error: e);
    rethrow;
  }
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
  try {
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
    logger.i('アイドルを登録しました。アイドル名: $name');
  } catch (e) {
    logger.e('アイドルの登録中にエラーが発生しました。アイドル名: $name', error: e);
    rethrow;
  }
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
  try {
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
    logger.i('曲を登録しました。曲名: $name');
  } catch (e) {
    logger.e('曲の登録中にエラーが発生しました。曲名: $name', error: e);
    rethrow;
  }
}

Future<void> uploadImageToStorage({
  required String table,
  required String path,
  required File file,
}) async {
  try {
    await supabase.storage.from(TableName.images).upload(path, file);
    logger.i('画像をストレージにアップロードしました');
  } catch (e) {
    if (e is StorageException) {
      logger.e('ストレージエラー: ${e.message}', error: e);
    } else if (e is SocketException) {
      logger.e('ネットワークエラー: ${e.message}', error: e);
    } else if (e is HttpException) {
      logger.e('HTTPエラー: ${e.message}', error: e);
    } else {
      logger.e('エラーが発生しました: $e', error: e);
    }
    rethrow;
  }
}

// READ
Future<List<Map<String, dynamic>>> fetchGroupMembers(int groupId) async {
  try {
    final response = await supabase
        .from(TableName.idol)
        .select()
        .eq(ColumnName.groupId, groupId);
    logger.i('グループメンバーリストを取得しました');
    return response;
  } catch (e) {
    logger.e('グループメンバーリストの取得中にエラーが発生しました', error: e);
    rethrow;
  }
}

Future<List<Map<String, dynamic>>> fetchCurrentUserInfo() async {
  try {
    final currentUserId = supabase.auth.currentUser!.id;
    final userInfo = await supabase
        .from(TableName.profiles)
        .select()
        .eq(ColumnName.id, currentUserId);
    logger.i('現在のユーザー情報を取得しました');
    return userInfo;
  } catch (e) {
    logger.e('現在のユーザー情報の取得中にエラーが発生しました', error: e);
    rethrow;
  }
}

String? fetchImageUrl(String imagePath) {
  try {
    final url = supabase.storage.from(TableName.images).getPublicUrl(imagePath);
    logger.i('画像URLを取得しました');
    return url;
  } catch (e) {
    logger.e('画像URLの取得中にエラーが発生しました', error: e);
    return null;
  }
}

Future<List<Map<String, dynamic>>> fetchIdAndNameList(String tableName) async {
  try {
    final response = await supabase
        .from(tableName)
        .select('${ColumnName.id}, ${ColumnName.name}');
    logger.i('$tableNameのIDと名前のリストを取得しました');
    return response;
  } catch (e) {
    logger.e('$tableNameのIDと名前のリストの取得中にエラーが発生しました', error: e);
    rethrow;
  }
}

int fetchSelectedDataIdFromName({
  required List<Map<String, dynamic>> list,
  required String? name,
}) {
  final selectedDataList =
      list.where((item) => item[ColumnName.name] == name).toList();
  if (selectedDataList.isEmpty) {
    logger.e('指定された名前: $name に対するデータが見つかりません');
    throw StateError('指定された名前: $name に対するデータが見つかりません');
  }
  final selectedData = selectedDataList.single;
  final selectedDataId = selectedData[ColumnName.id];
  logger.i('指定された名前: $name に対するデータIDを取得しました');
  return selectedDataId;
}

Future<List<Map<String, dynamic>>> fetchArtists() async {
  try {
    final response = await supabase.from(TableName.artists).select();
    logger.i('アーティストのリストを取得しました');
    return response;
  } catch (e) {
    logger.e('アーティストのリストの取得中にエラーが発生しました', error: e);
    rethrow;
  }
}

Future<Map<String, dynamic>> fetchArtistById(String id) async {
  try {
    final response = await supabase
        .from(TableName.artists)
        .select()
        .eq(ColumnName.id, id)
        .single();
    logger.i('ID: $id のアーティストを取得しました');
    return response;
  } catch (e) {
    logger.e('ID: $id のアーティストの取得中にエラーが発生しました', error: e);
    rethrow;
  }
}

Stream fetchDatabyStream({
  required String table,
  required String id,
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
  String? imageUrl,
  String? year,
  String? officialUrl,
  String? twitterUrl,
  String? instagramUrl,
  String? scheduleUrl,
  String? comment,
  required String id,
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
    logger.i('データを更新しました。グループ名: $name');
  } catch (e) {
    logger.e('データの更新中にエラーが発生しました。グループ名: $name', error: e);
    rethrow;
  }
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
  try {
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
    logger.i('データを更新しました。アイドル名: $name');
  } catch (e) {
    logger.e('データの更新中にエラーが発生しました。アイドル名: $name', error: e);
    rethrow;
  }
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
  try {
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
    logger.i('データを更新しました。曲名: $name');
  } catch (e) {
    logger.e('データの更新中にエラーが発生しました。曲名: $name', error: e);
    rethrow;
  }
}

Future<void> updateUser({
  required String name,
  required String email,
  required String imageUrl,
  String? comment,
  required String id,
}) async {
  try {
    await supabase.from(TableName.profiles).update({
      ColumnName.name: name,
      ColumnName.email: email,
      ColumnName.imageUrl: imageUrl,
      ColumnName.comment: comment,
    }).eq(ColumnName.id, id);
    logger.i('データを更新しました。ユーザー名: $name');
  } catch (e) {
    logger.e('データの更新中にエラーが発生しました。ユーザー名: $name', error: e);
    rethrow;
  }
}

// DELETE
Future<void> deleteDataFromTable({
  required String table,
  required String column,
  required String value,
}) async {
  try {
    await supabase.from(table).delete().eq(column, value);
    logger.i('データを削除しました。名前: $value');
  } catch (e) {
    logger.e('データの削除中にエラーが発生しました。名前: $value', error: e);
    rethrow;
  }
}
