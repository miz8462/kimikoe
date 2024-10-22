import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/user.dart';

final currentUserProvider = FutureProvider<UserProfile>((ref) async {
  final currentUserId = supabase.auth.currentUser!.id;
  final currentUser = await supabase
      .from(TableName.profiles.name)
      .select()
      .eq(ColumnName.id.name, currentUserId)
      .single();

  final user = UserProfile(
      id: currentUser[ColumnName.id.name],
      name: currentUser[ColumnName.cName.name],
      email: currentUser[ColumnName.email.name],
      imageUrl: currentUser[ColumnName.imageUrl.name],
      comment: currentUser[ColumnName.comment.name]);
  return user;
});
