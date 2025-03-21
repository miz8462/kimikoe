/*
  IdolGroupListScreenを元に作成
*/

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/favorite/favorite_provider.dart';
import 'package:kimikoe_app/providers/favorite/favorite_songs_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/widgets/card/song_card.dart';

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
    final favoriteSongsAsync = ref.watch(favoriteSongsProvider);

    return favoriteSongsAsync.when(
      data: (favoriteSongs) {
        if (favoriteSongs.isEmpty) {
          return const Center(
            key: Key(WidgetKeys.favoriteEmpty),
            child: Text('お気に入りの曲はありません'),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(favoriteNotifierProvider(FavoriteType.songs).notifier)
                  .fetchFavorites();
              ref.invalidate(favoriteSongsProvider);
            },
            child: Padding(
              padding: screenPadding,
              child: ListView.builder(
                itemCount: favoriteSongs.length,
                itemBuilder: (ctx, index) {
                  return SongCard(
                    key: Key(favoriteSongs[index].title),
                    song: favoriteSongs[index],
                    group: favoriteSongs[index].group!,
                    isFavoriteScreen: true,
                  );
                },
              ),
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
                  ref.refresh(favoriteNotifierProvider(FavoriteType.songs)),
              child: const Text('再試行'),
            ),
          ],
        ),
      ),
    );
  }
}
