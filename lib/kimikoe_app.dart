import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/router.dart';

// AppBarとBottomNavigationBarの設計
// bodyに子要素として各ページを受け取る

class KimikoeApp extends StatefulWidget {
  const KimikoeApp({super.key});

  @override
  State<KimikoeApp> createState() => _KimikoeAppState();
}

class _KimikoeAppState extends State<KimikoeApp> {
  late bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _checkIsLogin();
  }

  // todo: ログインしてるかどうか
  bool _checkIsLogin() {
    final session = supabase.auth.currentSession;
    print(session?.user.email);
    if (session != null) {
      isLogin = true;
    } else {
      isLogin = false;
    }
    print('isLogin: $isLogin');
    return isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      // 右上の赤いDebugを表示しない
      debugShowCheckedModeBanner: false,
      title: 'キミコエ',
      theme: ThemeData(primaryColor: mainBlue),
    );
  }
}
