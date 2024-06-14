import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/appbar/app_bar_divider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leadingウィジェット(左に表示されるウィジェット)のデフォルト幅は56
      leadingWidth: 110,
      leading: Padding(
        padding: const EdgeInsets.only(top: 12, left: 15.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image(
            image: const AssetImage('assets/images/Kimikoe_Logo.png'),
            height: AppBar().preferredSize.height,
          ),
        ),
      ),
      title: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          'Home',
          style: TextStyle(color: textDark, fontSize: fontLL),
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
