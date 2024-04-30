import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/color.dart';
import 'package:kimikoe_app/ui/auth/view/sign_in_page.dart';
import 'package:kimikoe_app/ui/home/view/home_page.dart';

class KimikoeApp extends StatelessWidget {
  const KimikoeApp({super.key});
  final bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上の赤いDebugを表示しない
      debugShowCheckedModeBanner: false,
      title: 'キミコエ',
      // ログインしている場合はHomeへ
      // していない場合はAuthへ
      home: (isLogin)
          ? Scaffold(
              appBar: AppBar(),
              body: HomePage(),
            )
          : SignInPage(),
      theme: ThemeData(primaryColor: mainBlue),
    );
  }
}
