import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/ui/auth/view/divide_line.dart';
import 'package:kimikoe_app/ui/auth/view/title_logo.dart';
import 'package:kimikoe_app/ui/widgets/social_login_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();

  // マジックリンク
  Future<void> _login() async {
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

  // googleログイン
  Future<void> _googleSignIn() async {}

  // twitterログイン
  Future<void> _twitterSignIn() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleLogo(),
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
                        // パスワードレス認証ボタン
                        FractionallySizedBox(
                          widthFactor: 1.0,
                          child: ElevatedButton(
                            onPressed: () => context.go('/home'),
                            // onPressed: _login,
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
                        DivideLine(),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialLoginButton(
                              _googleSignIn,
                              imagePath: 'assets/images/google.svg',
                            ),
                            SocialLoginButton(
                              _twitterSignIn,
                              imagePath: 'assets/images/twitter.svg',
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
    );
  }
}
