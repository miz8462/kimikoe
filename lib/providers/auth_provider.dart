import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends StateNotifier<Session?> {
  AuthNotifier() : super(null);

  Future<void> signIn(String email, String password, WidgetRef ref) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.session != null) {
      state = response.session;
      await ref.read(userProfileProvider.notifier).fetchUserProfile();
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> signOut(WidgetRef ref) async {
    await supabase.auth.signOut();
    state = null;
    ref.read(userProfileProvider.notifier).clearUserProfile();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, Session?>(
  (ref) => AuthNotifier(),
);
