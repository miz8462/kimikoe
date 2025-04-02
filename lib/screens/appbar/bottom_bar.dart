import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/bottom_bar_visibility/bottom_bar_visibility_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';

final iconSize = 30.0;
final iconRadius = 20.0;

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({
    required this.navigationShell,
    super.key,
  });
  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  int homeIndex = 0;
  int favoriteIndex = 1;
  int addIndex = 2;
  int userIndex = 3;

  void _openAddOverlay(BuildContext context) {
    showModalBottomSheet<Widget>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StyledButton(
                  '歌詞',
                  key: Key(WidgetKeys.addSong),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addSong);
                  },
                ),
                StyledButton(
                  'グループ',
                  key: Key(WidgetKeys.addGroup),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addGroup);
                  },
                ),
                StyledButton(
                  'アイドル',
                  key: Key(WidgetKeys.addIdol),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addIdol);
                  },
                ),
                StyledButton(
                  '作詞・作曲家',
                  key: Key(WidgetKeys.addArtist),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addArtist);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;
    final user = ref.watch(userProfileProvider);
    if (user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isVisible = ref.watch(bottomBarVisibilityNotifierProvider);
    logger.d('見えてるの見えてないの？ $isVisible');

    final imageUrl = user.imageUrl;

    // 横画面の時表示しない
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // 横画面時にシステムUIを非表示
    if (isLandscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: isLandscape || !isVisible
          ? null
          : NavigationBar(
              backgroundColor: Theme.of(context).primaryColor,
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                if (index == addIndex) {
                  _openAddOverlay(context);
                } else {
                  widget.navigationShell.goBranch(
                    index,
                    initialLocation:
                        index == widget.navigationShell.currentIndex,
                  );
                }
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    key: Key(WidgetKeys.homeButton),
                    Icons.home_outlined,
                    color: currentIndex == homeIndex ? textDark : textWhite,
                    size: iconSize,
                    semanticLabel: 'ホーム',
                  ),
                  label: '',
                ),
                NavigationDestination(
                  icon: Icon(
                    key: Key(WidgetKeys.favoriteButton),
                    Icons.star_border,
                    color: currentIndex == favoriteIndex ? textDark : textWhite,
                    size: iconSize,
                    semanticLabel: 'お気に入り',
                  ),
                  label: '',
                ),
                NavigationDestination(
                  icon: Icon(
                    key: Key(WidgetKeys.addButton),
                    Icons.add_box_outlined,
                    color: currentIndex == addIndex ? textDark : textWhite,
                    size: iconSize,
                    semanticLabel: '追加',
                  ),
                  label: '',
                ),
                NavigationDestination(
                  icon: CircleAvatar(
                    key: Key(WidgetKeys.userAvatar),
                    backgroundImage: NetworkImage(imageUrl),
                    // radius: avaterSizeS,
                    maxRadius: iconRadius,
                  ),
                  label: '',
                ),
              ],
            ),
    );
  }
}
