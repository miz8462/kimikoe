import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/ui/auth/view/divide_line.dart';
import 'package:kimikoe_app/ui/auth/view/title_logo.dart';
import 'package:kimikoe_app/ui/widgets/social_login_button.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // マジックリンク
  Future<void> magicLink() async {
    final email = _emailController.text.trim();
    await supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: 'io.supabase.kimikoe://login-callback/',
    );
    if (mounted) {
      // スナックバー通知
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check your inbox'),
        ),
      );
    }
  }

  // googleログイン
  Future<void> googleSignIn() async {}

  // twitterログイン
  Future<void> twitterSignIn() async {}

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
                          style: TextStyle(color: textWhite),
                          controller: _emailController,
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
                            onPressed: magicLink,
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
                              googleSignIn,
                              imagePath: 'assets/images/google.svg',
                            ),
                            SocialLoginButton(
                              twitterSignIn,
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
