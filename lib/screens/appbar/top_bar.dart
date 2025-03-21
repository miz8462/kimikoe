import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';

class TopBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    this.imageUrl,
    this.pageTitle = '',
    this.showLeading = true,
    this.isEditing = false,
    this.isGroup = false,
    this.isUser = false,
    this.editRoute,
    this.data,
    this.delete,
    this.logout,
    this.isStarred = false,
    this.hasFavoriteFeature = false,
    this.onStarToggle,
  });
  final String? imageUrl;
  final String pageTitle;
  final bool showLeading;
  final bool isEditing;
  final bool isGroup;
  final bool isUser;
  final String? editRoute;
  final Map<String, Object>? data;
  final void Function()? delete;
  final void Function()? logout;
  final bool isStarred;
  final bool hasFavoriteFeature;
  final VoidCallback? onStarToggle;

  // 編集、削除機能。グループ、ユーザーの時は削除なし
  List<Widget> _buildMenu(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: PopupMenuButton<int>(
          key: const Key(WidgetKeys.topBarMenu),
          icon: const Icon(Icons.more_vert),
          color: Colors.white,
          offset: const Offset(0, 40),
          onSelected: (item) {
            try {
              if (item == 0) {
                if (editRoute != null) {
                  context.pushNamed(editRoute!, extra: data);
                  logger.i('編集ルートへナビゲートしました: $editRoute');
                } else {
                  throw Exception('編集ルートがnullです');
                }
              } else if (item == 1 && !isGroup && !isUser) {
                delete?.call();
                logger.i('削除アクションがトリガーされました');
              } else if (item == 2 && isUser) {
                logout?.call();
                logger.i('ログアウトアクションがトリガーされました');
              }
            } catch (e) {
              logger.e('メニューアクションの処理中にエラーが発生しました', error: e);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('操作中にエラーが発生しました: $e'),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              key: const Key(WidgetKeys.edit),
              value: 0,
              child: ListTile(
                leading:
                    Icon(Icons.edit, color: Theme.of(context).primaryColor),
                title: Text('編集', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            if (!isGroup && !isUser)
              PopupMenuItem<int>(
                key: const Key(WidgetKeys.delete),
                value: 1,
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    '削除',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            if (isUser)
              PopupMenuItem<int>(
                key: const Key(WidgetKeys.logout),
                value: 2,
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'ログアウト',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: showLeading,
      title: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          pageTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25, color: mainColor),
        ),
      ),
      centerTitle: true,
      actions: [
        if (hasFavoriteFeature)
          IconButton(
            padding: const EdgeInsets.only(top: 10),
            icon: Icon(
              key: const Key(WidgetKeys.star),
              isStarred ? Icons.star : Icons.star_border,
              color: isStarred ? const Color.fromARGB(255, 231, 214, 58) : null,
            ),
            onPressed: onStarToggle,
          ),
        if (isEditing) ..._buildMenu(context),
      ],
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
      height: 2,
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: mainColor.withValues(alpha: 0.5),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}
