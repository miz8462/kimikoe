import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/widgets/social_login_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _redirecting = false;

  final _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  // マジックリンク
  Future<void> _signIn() async {
    await supabase.auth.signInWithOtp(
      email: 'wwr8462@gmail.com',
      // email: _emailController.text.trim(),
      emailRedirectTo: 'io.supabase.kimikoe://login-callback/',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check your email for a login link!')),
      );
      _emailController.clear();
    }
  }

  Future<void> _googleSignIn() async {
    /// Web Client ID that you registered with Google Cloud.
    final webClientId = dotenv.env['GOOGLE_OAUTH_WEB_CLIENT_ID'];

    /// iOS Client ID that you registered with Google Cloud.
    final iosClientId = dotenv.env['GOOGLE_OAUTH_IOS_CLIENT_ID'];

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

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
  }

  // twitterログイン
//   Future<void> _twitterSignIn() async {
//   await supabase.auth.signInWithOAuth(OAuthProvider.twitter);
// }

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
            context.go('/home');
          }
        }
      },
      onError: (error) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              flex: 4,
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
            Expanded(
              flex: 6,
              child: Container(
                color: mainBlue,
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Column(
                      children: [
                        const Gap(60),
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(color: textWhite),
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
                        // MagicLinkボタン
                        FractionallySizedBox(
                          widthFactor: 1.0,
                          child: ElevatedButton(
                            onPressed: _signIn,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            // childは引数リストの最後に書く
                            child: const Text(
                              "Send Magic Link",
                              style: TextStyle(
                                color: mainBlue,
                                fontSize: fontL,
                              ),
                            ),
                          ),
                        ),
                        const Gap(30),
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
    );
  }
}
