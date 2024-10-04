import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';

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

int fetchSelectedDataIdFromName(List<Map<String, dynamic>> list, String name) {
  final selectedData =
      list.where((item) => item[ColumnName.cName.name] == name).single;
  final selectedDataId = selectedData[ColumnName.id.name];
  return selectedDataId;
}

Future<void> deleteDataFromTable(
    String table, String column, String value) async {
  await supabase.from(table).delete().eq(column, value);
}
