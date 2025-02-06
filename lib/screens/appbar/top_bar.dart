import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
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

  // 編集、削除機能。グループ、ユーザーの時は削除なし
  List<Widget> _buildEditAndDeleteActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: PopupMenuButton<int>(
          key: const Key('top-bar-menu'),
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
              key: const Key('edit'),
              value: 0,
              child: ListTile(
                leading:
                    Icon(Icons.edit, color: Theme.of(context).primaryColor),
                title: Text('編集', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            if (!isGroup && !isUser)
              PopupMenuItem<int>(
                key: const Key('delete'),
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
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
      actions: isEditing ? _buildEditAndDeleteActions(context) : null,
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
