import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

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
                            onPressed: () {},
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
                              "    OR    ",
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
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                height: 40,
                                width: 40,
                                'assets/images/google.svg',
                                colorFilter: const ColorFilter.mode(
                                    textWhite, BlendMode.srcIn),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                height: 40,
                                width: 40,
                                'assets/images/twitter.svg',
                                colorFilter: const ColorFilter.mode(
                                    textWhite, BlendMode.srcIn),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Sign in with another account',
                          style: TextStyle(color: textWhite, fontSize: fontS),
                        )
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
