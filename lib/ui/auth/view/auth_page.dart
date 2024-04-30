import 'package:flutter/material.dart';
import 'package:kimikoe_app/main.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

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
                child: Image(
                  image: AssetImage('images/Kimikoe_Logo.png'),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                color: mainBlue,
                child: Center(
                  child: Text('青ページ'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
