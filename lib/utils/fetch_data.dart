import 'package:kimikoe_app/main.dart';

Future fetchUserInfo() {
    final currentUserId = supabase.auth.currentUser!.id;
    final userInfo =
        supabase.from('profiles').select().eq('id', currentUserId);
    return userInfo;
  }

  String fetchNoImage() {
    final String noImagePath =
        supabase.storage.from('images').getPublicUrl('no-images.png');
    return noImagePath;
  }