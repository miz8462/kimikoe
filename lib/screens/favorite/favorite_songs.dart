/*
  IdolGroupListScreenを元に作成
*/

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/favorite/favorite_provider.dart';
import 'package:kimikoe_app/providers/groups_provider.dart' show groupsProvider;
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/widgets/card/group_card_l.dart';

class FavoriteSongsScreen extends ConsumerStatefulWidget {
  const FavoriteSongsScreen({super.key});
  @override
  ConsumerState<FavoriteSongsScreen> createState() => _FavoriteSongsState();
}

class _FavoriteSongsState extends ConsumerState<FavoriteSongsScreen> {
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
    final groupList = ref.watch(groupsProvider);
    final groups = groupList.groups;
    final isGroupsLoading = groupList.isLoading;
    final favoriteGroupListAsync =
        ref.watch(favoriteNotifierProvider(FavoriteType.groups));

    return favoriteGroupListAsync.when(
      data: (favoriteGroupList) {
        var favoriteGroups = <IdolGroup>[];
        if (!isGroupsLoading && favoriteGroupList.isNotEmpty) {
          favoriteGroups = groups
              .where((group) => favoriteGroupList.contains(group.id))
              .toList();
        }

        // UIの構築
        if (isGroupsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (favoriteGroups.isEmpty) {
          return const Center(
            key: Key(WidgetKeys.favoriteEmpty),
            child: Text('お気に入りの曲はありません'),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(groupsProvider.notifier)
                  .fetchGroupList(supabase: supabase);
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
