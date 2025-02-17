import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/auth_provider.dart';
import 'package:kimikoe_app/providers/user_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/button/styled_button.dart';

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
  int addIndex = 1;
  int userIndex = 2;
  int logoutIndex = 3;

  void _openAddOverlay(BuildContext context) {
    setState(() {
      widget.navigationShell.goBranch(addIndex);
    });
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

  Future<void> _signOut() async {
    await ref.read(authProvider.notifier).logout(ref);
    if (mounted) {
      context.go('/');
    }
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

    final imageUrl = user.imageUrl;

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          if (index == addIndex) {
            _openAddOverlay(context);
          } else if (index == logoutIndex) {
            _signOut();
          } else {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: currentIndex == homeIndex ? textDark : textWhite,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              key: Key(WidgetKeys.addButton),
              Icons.add_box_outlined,
              color: currentIndex == addIndex ? textDark : textWhite,
            ),
            label: '',
          ),
          NavigationDestination(
            icon: CircleAvatar(
              key: Key(WidgetKeys.userAvatar),
              backgroundImage: NetworkImage(imageUrl),
              radius: avaterSizeS,
            ),
            label: '',
          ),
          // TODO: 開発用ログアウトボタン
          NavigationDestination(
            icon: Icon(key: Key(WidgetKeys.logoutButton), Icons.logout),
            label: '',
          ),
        ],
      ),
    );
  }
}
