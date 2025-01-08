import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends StateNotifier<Session?> {
  AuthNotifier() : super(null);

  Future<void> login(String email, String password, WidgetRef ref) async {
    if (!mounted) return;
    try {
      logger.i('ログインを試みています: email = $email');
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.session != null) {
        if (mounted) {
          state = response.session;
          logger.i('ログインに成功しました: userId = ${response.session!.user.id}');
          await ref.read(userProfileProvider.notifier).fetchUserProfile();
        }
      } else {
        logger.w('ログインに失敗しました: 認証情報が無効です');
        throw Exception('ログインに失敗しました');
      }
    } catch (e, stackTrace) {
      logger.e('ログイン中にエラーが発生しました', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> logout(WidgetRef ref) async {
    try {
      logger.i('ログアウトを試みています');
      await supabase.auth.signOut();
      state = null;
      logger.i('ログアウトに成功しました');
      ref.read(userProfileProvider.notifier).clearUserProfile();
    } catch (e, stackTrace) {
      logger.e('ログアウト中にエラーが発生しました', error: e, stackTrace: stackTrace);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, Session?>(
  (ref) => AuthNotifier(),
);
