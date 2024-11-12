import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/user.dart';
import 'package:kimikoe_app/utils/crud_data.dart';

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null);

  Future<void> fetchUserProfile() async {
    final currentUserId = supabase.auth.currentUser!.id;
    final currentUser = await supabase
        .from(TableName.profiles.name)
        .select()
        .eq(ColumnName.id.name, currentUserId)
        .single();

    state = UserProfile(
        id: currentUser[ColumnName.id.name],
        name: currentUser[ColumnName.cName.name],
        email: currentUser[ColumnName.email.name],
        imageUrl: currentUser[ColumnName.imageUrl.name],
        comment: currentUser[ColumnName.comment.name]);
  }

  void clearUserProfile() {
    state = null;
  }

  Future<void> updateUserProfile(UserProfile newUser) async {
    final currentUserId = supabase.auth.currentUser!.id;
    await updateUser(
      id: currentUserId,
      name: newUser.name,
      email: newUser.email,
      imageUrl: newUser.imageUrl,
      comment: newUser.comment,
    );

    state = newUser;
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>(
        (ref) => UserProfileNotifier()..fetchUserProfile());
