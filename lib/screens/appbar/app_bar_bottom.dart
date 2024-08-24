import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.0,
      decoration: BoxDecoration(color: mainBlue.withOpacity(0.3), boxShadow: [
        BoxShadow(
          color: mainBlue.withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 2,
        )
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}
