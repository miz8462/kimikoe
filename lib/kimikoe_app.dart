import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/home/view/home_page.dart';
import 'package:kimikoe_app/ui/auth/view/log_in_page.dart';
import 'package:kimikoe_app/ui/auth/view/splash_page.dart';

// AppBarとBottomNavigationBarの設計
// bodyに子要素として各ページを受け取る

class KimikoeApp extends StatelessWidget {
  const KimikoeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上の赤いDebugを表示しない
      debugShowCheckedModeBanner: false,
      title: 'キミコエ',
      theme: ThemeData(primaryColor: mainBlue),
      // ログインしている場合はHomePageへ
      // していない場合はSignInPageへ
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LogInPage(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}
