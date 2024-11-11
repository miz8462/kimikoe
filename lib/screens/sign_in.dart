import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/providers/auth.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/buttons/social_login_button.dart';
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
        break;
      case 'user_already_exists':
        errorMessage = 'ユーザーはすでに存在しています。ログインを試してください。';
        break;
      case 'user_not_found':
        errorMessage = 'ユーザーが見つかりません。メールアドレスを確認するか、新しいアカウントを作成してください。';
        break;
      case 'invalid_credentials':
        errorMessage = 'メールアドレスまたはパスワードが正しくありません。もう一度確認してください。';
        break;
      default:
        errorMessage = 'エラーが発生しました: ${error.message}';
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }

  Future<void> _signUp() async {
    if (!_validateAndSaveForm()) {
      return;
    }

    try {
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
        await supabase.from(TableName.profiles.name).update({
          ColumnName.cName.name: userData!['username'],
          ColumnName.imageUrl.name: noImage,
        }).eq(
          ColumnName.id.name,
          userId,
        );
      }
      await Future.delayed(Duration(milliseconds: 200));
    } on AuthException catch (e) {
      if (!mounted) return;
      _showErrorMessage(e);
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
      await ref.read(authProvider.notifier).signIn(
            _enteredEmail,
            _enteredPassword,
            ref,
          );
      await Future.delayed(Duration(milliseconds: 200));
    } on AuthException catch (e) {
      if (!mounted) return;
      _showErrorMessage(e);
    }

    if (mounted) {
      context.go(RoutingPath.groupList);
    }
  }

  // // マジックリンク
  // Future<void> _sendMagicLink() async {
  //   try {
  //     await supabase.auth.signInWithOtp(
  //       email: _emailController.text.trim(),
  //       emailRedirectTo: 'io.supabase.kimikoe://login-callback/',
  //     );
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //       Glogin link!')),
  //       );
  //       _emailController.clear();
  //     }
  //   } catch (e) {
  //     print('Failed to send magic link: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to send magic link: $e')));
  //     }
  //   }
  // }

  Future<void> _googleSignIn() async {
    final webClientId = dotenv.env['GOOGLE_OAUTH_WEB_CLIENT_ID'];
    final iosClientId = dotenv.env['GOOGLE_OAUTH_IOS_CLIENT_ID'];

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final userId = supabase.auth.currentUser!.id;
      final userData = supabase.auth.currentUser!.userMetadata;

      final response = await supabase
          .from(TableName.profiles.name)
          .select()
          .eq(ColumnName.id.name, userId);

      if (response[0]['email'] == null) {
        await supabase.from('profiles').update({
          'name': userData?['name'],
          'email': userData?['email'],
          'image_url': userData?['image_url']
        }).eq('id', userId);
      }

      await ref.read(userProfileProvider.notifier).fetchUserProfile();

      await Future.delayed(Duration(microseconds: 200));
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) async {
        if (_isRedirecting) return;
        final session = data.session;
        if (session != null) {
          _isRedirecting = true;
          if (mounted) {
            context.go(RoutingPath.groupList);
          }
        }
      },
      onError: (error) {
        if (!mounted) {
          return;
        }
        if (error is AuthException) {
          context.showSnackBar(error.message, isError: true);
        } else {
          context.showSnackBar('Unexpected error occurred', isError: true);
        }
      },
    );
    super.initState();
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
                color: mainBlue,
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
                                  color: Colors.yellowAccent, fontSize: 16),
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
                                  color: Colors.yellowAccent, fontSize: 16),
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
                                    color: Colors.yellowAccent, fontSize: 16),
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
                              onPressed: _isLogin ? _logIn : _signUp,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                _isLogin ? "Login" : "Signup",
                                style: TextStyle(
                                  color: mainBlue,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onError),
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
                                "    Social Login    ",
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
                              // SocialLoginButton(
                              //   _twitterSignIn,
                              //   imagePath: 'assets/images/twitter.svg',
                              // ),
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
