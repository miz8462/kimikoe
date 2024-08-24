import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/screens/appbar/app_bar_bottom.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    this.imageUrl,
    this.title,
  });
  final String? imageUrl;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final localImage = imageUrl;
    final localTitle = title;
    return AppBar(
      automaticallyImplyLeading: true,
      title: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            if (imageUrl != null)
              Image(
                image: AssetImage(localImage!),
                height: 40,
              ),
            if (localTitle != null)
              Text(
                localTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, color: mainBlue),
              ),
          ],
        ),
      ),
      centerTitle: true,
      bottom: AppBarBottom(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
