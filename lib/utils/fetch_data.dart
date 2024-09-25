import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';

Future fetchCurrentUserInfo() {
  final currentUserId = supabase.auth.currentUser!.id;
  final userInfo = supabase
      .from(TableName.profiles.name)
      .select()
      .eq(ColumnName.id.colname, currentUserId);
  return userInfo;
}

String fetchImageOfNoImage() {
  final String noImagePath = supabase.storage
      .from(TableName.images.name)
      .getPublicUrl(noImage);
  return noImagePath;
}

String fetchImage(String imageUrl) {
  return supabase.storage.from(TableName.images.name).getPublicUrl(imageUrl);
}

Future<List<Map<String, dynamic>>> fetchIdAndNameList(String tableName) async {
  return await supabase
      .from(tableName)
      .select('${ColumnName.id.colname}, ${ColumnName.name.colname}');
}

int fetchSelectedDataIdFromName(
      List<Map<String, dynamic>> list, String name) {
    final selectedData =
        list.where((item) => item[ColumnName.name.colname] == name).single;
    final selectedDataId = selectedData[ColumnName.id.colname];
    return selectedDataId;
  }