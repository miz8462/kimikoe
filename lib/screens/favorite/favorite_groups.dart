/*
  IdolGroupListScreenを元に作成
*/

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/favorite/favorite_groups_provider.dart';
import 'package:kimikoe_app/providers/favorite/favorite_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/widgets/card/group_card_l.dart';

class FavoriteGroupsScreen extends ConsumerStatefulWidget {
  const FavoriteGroupsScreen({super.key});
  @override
  ConsumerState<FavoriteGroupsScreen> createState() => _FavoriteGroupsState();
}

class _FavoriteGroupsState extends ConsumerState<FavoriteGroupsScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  // グループリストページを開く際、ネットに繋がっていない場合
  // エラーメッセージを表示する。connectivity_plus
  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      logger.e('インターネットに接続されていません');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('インターネットに接続されていません。接続を確認してください'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteGroupsAsync = ref.watch(favoriteGroupsProvider);

    return favoriteGroupsAsync.when(
      data: (favoriteGroups) {
        if (favoriteGroups.isEmpty) {
          return const Center(
            key: Key(WidgetKeys.favoriteEmpty),
            child: Text('お気に入りのグループはありません'),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(favoriteNotifierProvider(FavoriteType.groups).notifier)
                  .fetchFavorites();
              ref.invalidate(favoriteGroupsProvider);
            },
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 15,
              ),
              itemCount: favoriteGroups.length,
              itemBuilder: (BuildContext context, int index) {
                final group = favoriteGroups[index];
                return GroupCardL(group: group);
              },
            ),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('エラー: $error'),
            ElevatedButton(
              onPressed: () =>
                  ref.refresh(favoriteNotifierProvider(FavoriteType.groups)),
              child: const Text('再試行'),
            ),
          ],
        ),
      ),
    );
  }
}
