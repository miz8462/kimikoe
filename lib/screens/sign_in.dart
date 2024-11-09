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
  late final StreamSubscription<AuthState> _authStateSubscription;

  // マジックリンク
  Future<void> _sendMagicLink() async {
    try {
      await supabase.auth.signInWithOtp(
        email: _emailController.text.trim(),
        emailRedirectTo: 'io.supabase.kimikoe://login-callback/',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email for a login link!')),
        );
        _emailController.clear();
      }
    } catch (e) {
      print('Failed to send magic link: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send magic link: $e')));
      }
    }
  }

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
                        TextField(
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
                        // MagicLinkボタン
                        FractionallySizedBox(
                          widthFactor: 1.0,
                          child: ElevatedButton(
                            onPressed: _sendMagicLink,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
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
            ],
          ),
        ),
      ),
    );
  }
}
