import 'package:kimikoe_app/main.dart';

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

Future<List<Map<String, dynamic>>> fetchGroupIdAndNameList() async {
  return await supabase.from('idol-groups').select('id, name');
}
