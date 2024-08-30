import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    this.imageUrl,
    this.title,
    this.showLeading = true,
  });
  final String? imageUrl;
  final String? title;
  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    final localImage = imageUrl;
    final localTitle = title;
    return AppBar(
      automaticallyImplyLeading: showLeading,
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

class AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
  Size get preferredSize => const Size.fromHeight(0);
}
