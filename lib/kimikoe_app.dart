import 'package:flutter/material.dart';
import 'package:kimikoe_app/ui/auth/view/auth_page.dart';

class KimikoeApp extends StatelessWidget {
  const KimikoeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'キミコエ',
      home: AuthPage(),
    );
  }
}