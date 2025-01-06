import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/auth_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthMethods {
  AuthMethods({
    required this.context,
    required this.ref,
    required this.formKey,
  });

  final BuildContext context;
  final WidgetRef ref;
  final GlobalKey<FormState> formKey;

  bool _validateAndSaveForm() {
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      return false;
    }

    formKey.currentState!.save();
    return true;
  }

  void _showErrorMessage(AuthException error) {
    String errorMessage;
    switch (error.code) {
      case 'email_exists':
        errorMessage = 'メールアドレスは既に登録されています。別のメールアドレスを使用してください。';
      case 'user_already_exists':
        errorMessage = 'ユーザーはすでに存在しています。ログインを試してください。';
      case 'user_not_found':
        errorMessage = 'ユーザーが見つかりません。メールアドレスを確認するか、新しいアカウントを作成してください。';
      case 'invalid_credentials':
        errorMessage = 'メールアドレスまたはパスワードが正しくありません。もう一度確認してください。';
      default:
        errorMessage = 'エラーが発生しました: ${error.message}';
    }

    logger.e('認証エラーが発生しました。エラーメッセージ: $errorMessage');

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }

  void _handleAuthError(AuthException error, String operation) {
    _showErrorMessage(error);
    logger.e('$operation 中に認証エラーが発生しました。エラーメッセージ: ${error.message}');
  }

  void handleGeneralAuthError(Object error, StackTrace stackTrace) {
    logger.e('認証エラーが発生しました。詳細: $error, $stackTrace');
    if (error is AuthException) {
      logger.e('AuthExceptionの詳細: ${error.code}, ${error.message}');
    }
    if (formKey.currentState?.mounted ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('認証エラーが発生しました'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    if (!_validateAndSaveForm()) {
      return;
    }

    try {
      logger.d('サインアップを開始しました。メールアドレス: $email');
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': name,
        },
      );

      final userId = response.user?.id;
      final userData = response.user?.userMetadata;
      if (userId != null) {
        await supabase.from(TableName.profiles).update({
          ColumnName.name: userData!['username'],
          ColumnName.imageUrl: noImage,
        }).eq(
          ColumnName.id,
          userId,
        );
      }
      logger.i('サインアップが成功しました。ユーザーID: $userId');

      await Future<dynamic>.delayed(Duration(milliseconds: 200));
    } on AuthException catch (e) {
      if (!formKey.currentState!.mounted) return;
      _handleAuthError(e, 'サインアップ');
      return;
    }

    // if(mounted)ではウィジェットが破棄されたタイミングでウィジェットを確認していたためエラーになる
    // 現在のフレームのレンダリングが完了した後にコールバックを実行
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(RoutingPath.groupList);
    });
  }

  Future<void> logIn(String email, String password) async {
    if (!_validateAndSaveForm()) {
      return;
    }

    try {
      await ref.read(authProvider.notifier).logIn(
            email,
            password,
            ref,
          );
      logger.i('ログインが成功しました。メールアドレス: $email');

      await Future<dynamic>.delayed(Duration(milliseconds: 200));
    } on AuthException catch (e) {
      if (!formKey.currentState!.mounted) return;
      _handleAuthError(e, 'ログイン');
    }

    // if(mounted)ではウィジェットが破棄されたタイミングでウィジェットを確認していたためエラーになる
    // 現在のフレームのレンダリングが完了した後にコールバックを実行
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(RoutingPath.groupList);
    });
  }

  Future<void> googleSignIn() async {
    final webClientId = dotenv.env['GOOGLE_OAUTH_WEB_CLIENT_ID'];
    final iosClientId = dotenv.env['GOOGLE_OAUTH_IOS_CLIENT_ID'];

    try {
      logger.d('Googleサインインを開始しました。');

      final googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw Exception('アクセストークンが見つかりません。');
      }
      if (idToken == null) {
        throw Exception('IDトークンが見つかりません。');
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      await ref.read(userProfileProvider.notifier).fetchUserProfile();
      logger.i('Googleサインインが成功しました。ユーザー: ${googleUser.displayName}');

      await Future<dynamic>.delayed(Duration(microseconds: 200));
    } catch (e) {
      logger.e('Googleサインインエラー: $e');
    }
  }
}
