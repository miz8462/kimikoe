import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/auth_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/button/social_login_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isRedirecting = false;

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredName = '';
  var _isLogin = true;

  late final StreamSubscription<AuthState> _authStateSubscription;

  bool _validateAndSaveForm() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return false;
    }

    _formKey.currentState!.save();
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

  void _handleGeneralAuthError(Object error) {
    logger.e('認証エラーが発生しました。エラーメッセージ: $error');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('認証エラーが発生しました'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _signUp() async {
    if (!_validateAndSaveForm()) {
      return;
    }

    try {
      logger.d('サインアップを開始しました。メールアドレス: $_enteredEmail');
      final response = await supabase.auth.signUp(
        email: _enteredEmail,
        password: _enteredPassword,
        data: {
          'username': _enteredName,
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
      if (!mounted) return;
      _handleAuthError(e, 'サインアップ');
      return;
    }

    if (mounted) {
      context.goNamed(RoutingPath.groupList);
    }
  }

  Future<void> _logIn() async {
    if (!_validateAndSaveForm()) {
      return;
    }

    try {
      await ref.read(authProvider.notifier).logIn(
            _enteredEmail,
            _enteredPassword,
            ref,
          );
      logger.i('ログインが成功しました。メールアドレス: $_enteredEmail');

      await Future<dynamic>.delayed(Duration(milliseconds: 200));
    } on AuthException catch (e) {
      if (!mounted) return;
      _handleAuthError(e, 'ログイン');
    }

    if (mounted) {
      context.go(RoutingPath.groupList);
    }
  }

  Future<void> _googleSignIn() async {
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

  @override
  void initState() {
    super.initState();
    if (isDebugMode) {
      logger.d('initStateが呼び出されました');
    }

    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) async {
        if (_isRedirecting) return;
        final session = data.session;
        if (session != null) {
          _isRedirecting = true;
          if (mounted) {
            context.go(RoutingPath.groupList);
            logger.i('セッションが存在します。リダイレクトを開始します');
          }
        }
      },
      onError: (Object error) {
        if (!mounted) {
          return;
        }
        if (error is AuthException) {
          context.showSnackBar(error.message, isError: true);
          logger.e('認証エラーが発生しました: ${error.message}');
        } else {
          context.showSnackBar('予期しないエラーが発生しました', isError: true);
          logger.e('予期しないエラーが発生しました: $error');
        }
      },
    );
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
    if (isDebugMode) {
      logger.d('disposeが呼び出されました');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 80),
                      Image(
                        image: AssetImage('assets/images/Kimikoe_Logo.png'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 800,
                color: mainColor,
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Gap(60),
                          TextFormField(
                            style: const TextStyle(color: textWhite),
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 16,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: textWhite,
                                ),
                              ),
                              hintText: 'E-Mail',
                              hintStyle: TextStyle(
                                fontSize: fontL,
                                color: textWhite,
                              ),
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: textWhite,
                                size: fontL,
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return '正しいE-Mailを入力してください';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          const Gap(20),
                          TextFormField(
                            style: const TextStyle(color: textWhite),
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 16,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: textWhite,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                fontSize: fontL,
                                color: textWhite,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: textWhite,
                                size: fontL,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 8) {
                                return _isLogin
                                    ? '正しいパスワードを入力してください'
                                    : 'パスワードは8文字以上入力してください';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          Gap(spaceS),
                          if (!_isLogin)
                            TextFormField(
                              style: const TextStyle(color: textWhite),
                              autocorrect: false,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(
                                  color: Colors.yellowAccent,
                                  fontSize: 16,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: textWhite,
                                  ),
                                ),
                                hintText: 'name',
                                hintStyle: TextStyle(
                                  fontSize: fontL,
                                  color: textWhite,
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: textWhite,
                                  size: fontL,
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 2) {
                                  return '名前は2文字以上入力してください';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredName = value!;
                              },
                            ),
                          const Gap(20),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  _isLogin ? await _logIn() : await _signUp();
                                } catch (error) {
                                  _handleGeneralAuthError(error);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                _isLogin ? 'ログイン' : 'サインアップ',
                                style: TextStyle(
                                  color: mainColor,
                                  fontSize: fontL,
                                ),
                              ),
                            ),
                          ),
                          const Gap(6),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? '新規登録する' : 'アカウントを持っている',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                            ),
                          ),
                          const Gap(12),
                          const Row(
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  color: textWhite,
                                  thickness: 2,
                                ),
                              ),
                              Text(
                                '    Googleログイン    ',
                                style: TextStyle(
                                  color: textWhite,
                                  fontSize: fontS,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: textWhite,
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialLoginButton(
                                _googleSignIn,
                                imagePath: 'assets/images/google.svg',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
