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
    this.isGroup = false,
    this.data,
    this.delete,
  });
  final String? imageUrl;
  final String? title;
  final bool showLeading;
  final bool hasEditingMode;
  final bool isGroup;
  final Map<String, Object>? data;
  final void Function()? delete;

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
      // 編集、削除機能。グループの時は削除はなし
      actions: hasEditingMode
          ? isGroup
              ? [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 16),
                    child: MenuAnchor(
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () {
                            context.pushNamed(RoutingPath.addGroup,
                                extra: data);
                          },
                          child: Text('編集'),
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
              : [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 16),
                    child: MenuAnchor(
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () {
                            context.pushNamed(RoutingPath.addGroup,
                                extra: data);
                          },
                          child: Text('編集'),
                        ),
                        MenuItemButton(
                          onPressed: delete,
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
