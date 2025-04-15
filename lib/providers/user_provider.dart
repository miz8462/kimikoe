import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/user_profile.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier(this.ref) : super(null);
  final Ref ref;

  Future<void> fetchUserProfile() async {
    final supabase = ref.watch(supabaseProvider);
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      logger.i('ユーザーがログインしていません');
      return;
    }
    final currentUserId = currentUser.id;

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
    WidgetRef ref,
  ) async {
    try {
      final client = ref.watch(supabaseProvider);
      final currentUserId = client.auth.currentUser!.id;
      logger.i('ユーザーのプロフィールを更新中...');

      final service = ref.read(supabaseServicesProvider);
      await service.update.updateUser(
        id: currentUserId,
        name: newUser.name,
        email: newUser.email,
        imageUrl: newUser.imageUrl,
        comment: newUser.comment,
        context: context,
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
  (ref) => UserProfileNotifier(ref)..fetchUserProfile(),
);
