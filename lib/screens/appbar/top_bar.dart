import 'package:flutter/material.dart';
import 'package:kimikoe_app/screens/appbar/app_bar_divider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Image(
          image: const AssetImage('assets/images/Kimikoe_Logo.png'),
          height: 40,
        ),
      ),
      centerTitle: true,
      // AppBarの下にライン
      bottom: AppBarDivider(),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 1); // AppBarの高さ + 線の高さ
}
