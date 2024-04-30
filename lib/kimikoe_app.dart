import 'package:flutter/material.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/ui/auth/view/auth_page.dart';

class KimikoeApp extends StatelessWidget {
  const KimikoeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上の赤いDebugを表示しない
      debugShowCheckedModeBanner: false,
      title: 'キミコエ',
      home: const AuthPage(),
      theme: ThemeData(primaryColor: mainBlue),
    );
  }
}
