import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/buttons/social_login_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _redirecting = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  var _isLogin = true;

  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signUp() async {
    try {
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = 'ユーザーネーム未定';
      }
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        data: {
          'username': _nameController.text.trim(),
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
      if (mounted) {
        context.goNamed(RoutingPath.groupList);
      }
      // todo: エラー処理
    } on AuthException catch (e) {
    } on Exception catch (e) {}
  }

  Future<void> _logIn() async {
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await Future.delayed(Duration(milliseconds: 200));

      if (mounted) {
        context.go(RoutingPath.groupList);
      }
      // todo: エラー処理
    } on AuthException catch (e) {
    } on Exception catch (e) {}
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
    /// Web Client ID that you registered with Google Cloud.
    final webClientId = dotenv.env['GOOGLE_OAUTH_WEB_CLIENT_ID'];

    /// iOS Client ID that you registered with Google Cloud.
    final iosClientId = dotenv.env['GOOGLE_OAUTH_IOS_CLIENT_ID'];

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

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

      await Future.delayed(Duration(microseconds: 500));
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) async {
        if (_redirecting) return;
        final session = data.session;
        if (session != null) {
          _redirecting = true;
          await Future.delayed(Duration.zero);
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
          context.showSnackBar('Unexpected error occurrded', isError: true);
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                height: 400,
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
                height: 600,
                color: mainBlue,
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Column(
                      children: [
                        const Gap(60),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: textWhite),
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
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
                        ),
                        const Gap(20),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: textWhite),
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
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
                        ),
                        Gap(spaceS),
                        if (!_isLogin)
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: textWhite),
                            autocorrect: false,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
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
                                    color:
                                        Theme.of(context).colorScheme.onError),
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
            ],
          ),
        ),
      ),
    );
  }
}
