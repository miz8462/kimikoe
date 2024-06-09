import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/auth/view/sign_in_page.dart';
import 'package:kimikoe_app/ui/lyric/lyric_page.dart';
import 'package:kimikoe_app/ui/widgets/appbar/kimikoe_app_bar.dart';
import 'package:kimikoe_app/ui/widgets/appbar/kimikoe_bottom_navigation_bar.dart';

// AppBarとBottomNavigationBarの設計
// bodyに子要素として各ページを受け取る

class KimikoeApp extends StatelessWidget {
  const KimikoeApp({super.key});
  // todo: ログインしてるかどうか
  final bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.05;
    return MaterialApp(
      // 右上の赤いDebugを表示しない
      debugShowCheckedModeBanner: false,
      title: 'キミコエ',
      // ログインしている場合はHomeへ
      // していない場合はサインインへ
      home: (isLogin)
          ? Scaffold(
              appBar: KimikoeAppBar(),
              // ログインしている場合はホームへ
              // してない場合はサインインページへ
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: LyricPage(),
              ),
              // todo: アイコンをタップすると画面遷移
              bottomNavigationBar: KimikoeBottomNavigationBar(),
            )
          // ログインしていない場合はサインインへ
          : const Scaffold(body: SignInPage()),
      theme: ThemeData(primaryColor: mainBlue),
    );
  }
}




