import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/user_profile.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/services/supabase_service.dart';

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null);

  Future<void> fetchUserProfile() async {
    final currentUserId = supabase.auth.currentUser!.id;

    try {
      logger.i('ユーザーID $currentUserId のプロフィールを取得中...');
      final currentUser = await supabase
          .from(TableName.profiles)
          .select()
          .eq(ColumnName.id, currentUserId)
          .single();

      state = UserProfile(
        id: currentUser[ColumnName.id],
        name: currentUser[ColumnName.name],
        email: currentUser[ColumnName.email],
        imageUrl: currentUser[ColumnName.imageUrl],
        comment: currentUser[ColumnName.comment],
      );
      logger.i('ユーザーID $currentUserId のプロフィールを取得しました');
    } catch (e, stackTrace) {
      logger.e(
        'ユーザーID $currentUserId のプロフィールを取得中にエラーが発生しました',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void clearUserProfile() {
    state = null;
    logger.i('ユーザープロフィールをクリアしました');
  }

  Future<void> updateUserProfile(
    UserProfile newUser,
    BuildContext context,
  ) async {
    try {
      final currentUserId = supabase.auth.currentUser!.id;
      logger.i('ユーザーのプロフィールを更新中...');
      await updateUser(
        id: currentUserId,
        name: newUser.name,
        email: newUser.email,
        imageUrl: newUser.imageUrl,
        comment: newUser.comment,
        context: context,
        supabase: supabase,
      );

      state = newUser;
      logger.i('ユーザーのプロフィールを更新しました');
    } catch (e, stackTrace) {
      logger.e('ユーザーのプロフィールを更新中にエラーが発生しました', error: e, stackTrace: stackTrace);
    }
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>(
  (ref) => UserProfileNotifier()..fetchUserProfile(),
);
