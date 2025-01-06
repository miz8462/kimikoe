import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/services/auth_methods.dart';
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
  late final AuthMethods _authMethods;

  Future<void> _signUp() async {
    await _authMethods.signUp(_enteredEmail, _enteredPassword, _enteredName);
  }

  Future<void> _logIn() async {
    await _authMethods.logIn(_enteredEmail, _enteredPassword);
  }

  Future<void> _googleSignIn() async {
    await _authMethods.googleSignIn();
  }

  @override
  void initState() {
    super.initState();

    _authMethods = AuthMethods(
      context: context,
      ref: ref,
      formKey: _formKey,
    );

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
                              if (value == null) {
                                logger.e('メールアドレスがnullです');
                              }
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
                              if (value == null) {
                                logger.e('パスワードがnullです');
                              }
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
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  try {
                                    _isLogin ? await _logIn() : await _signUp();
                                  } catch (error, stackTrace) {
                                    _authMethods.handleGeneralAuthError(
                                        error, stackTrace);
                                  }
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
