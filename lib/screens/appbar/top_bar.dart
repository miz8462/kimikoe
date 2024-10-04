import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    this.imageUrl,
    this.title,
    this.showLeading = true,
    this.hasEditingMode = false,
    this.data,
    this.deleteGroup,
  });
  final String? imageUrl;
  final String? title;
  final bool showLeading;
  final bool hasEditingMode;
  final Map<String, Object>? data;
  final void Function()? deleteGroup;

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
      actions: hasEditingMode
          ? [
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 16),
                child: MenuAnchor(
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () {
                        context.pushNamed(RoutingPath.addGroup, extra: data);
                      },
                      child: Text('編集'),
                    ),
                    MenuItemButton(
                      onPressed: deleteGroup,
                      child: Text(
                        '削除',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                  builder: (_, MenuController controller, Widget? child) {
                    return IconButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: Icon(Icons.more_vert));
                  },
                ),
              ),
            ]
          : null,
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
