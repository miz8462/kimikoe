import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class AppBarDivider extends StatelessWidget implements PreferredSizeWidget {
  const AppBarDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // 両端の空白
      child: Container(
        height: 2.0,
        decoration: BoxDecoration(color: mainBlue.withOpacity(0.3), boxShadow: [
          BoxShadow(
            color: mainBlue.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
          )
        ]),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(1); // 線の高さ
}