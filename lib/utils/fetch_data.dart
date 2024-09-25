import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';

Future fetchCurrentUserInfo() {
  final currentUserId = supabase.auth.currentUser!.id;
  final userInfo = supabase.from('profiles').select().eq('id', currentUserId);
  return userInfo;
}

String fetchImageOfNoImage() {
  final String noImagePath =
      supabase.storage.from('images').getPublicUrl('no-images.png');
  return noImagePath;
}

String fetchImage(String imageUrl) {
  return supabase.storage.from(TableName.images.name).getPublicUrl(imageUrl);
}

Future<List<Map<String, dynamic>>> fetchIdAndNameList(String tableName) async {
  return await supabase.from(tableName).select('id, name');
}
