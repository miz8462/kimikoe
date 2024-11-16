import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/kimikoe_app.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    this.imageUrl,
    this.pageTitle,
    this.showLeading = true,
    this.isEditing = false,
    this.isGroup = false,
    this.isUser = false,
    this.editRoute,
    this.data,
    this.delete,
  });
  final String? imageUrl;
  final String? pageTitle;
  final bool showLeading;
  final bool isEditing;
  final bool isGroup;
  final bool isUser;
  final String? editRoute;
  final Map<String, Object>? data;
  final void Function()? delete;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showLeading,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          pageTitle!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, color: mainColor),
        ),
      ),
      centerTitle: true,
      // 編集、削除機能。グループ、ユーザーの時は削除なし
      actions: isEditing
          ? isGroup || isUser
              ? [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: MenuAnchor(
                      menuChildren: [
                        SizedBox(
                          width: 100,
                          child: MenuItemButton(
                            onPressed: () {
                              context.pushNamed(editRoute!, extra: data);
                            },
                            child: const Text('編集'),
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
                            icon: const Icon(Icons.more_vert));
                      },
                    ),
                  ),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: MenuAnchor(
                      menuChildren: [
                        SizedBox(
                          width: 80,
                          child: MenuItemButton(
                            onPressed: () {
                              context.pushNamed(editRoute!, extra: data);
                            },
                            child: Center(
                              child: Text(
                                '編集',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: MenuItemButton(
                            onPressed: delete,
                            child: Center(
                              child: Text(
                                '削除',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                              ),
                            ),
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
                            icon: const Icon(Icons.more_vert));
                      },
                    ),
                  ),
                ]
          : null,
      bottom: const AppBarBottom(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class AppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.0,
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}
