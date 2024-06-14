import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    required this.navigationShell,
    super.key,
  });
  final StatefulNavigationShell navigationShell;

  // void _logout() async {}
  @override
  Widget build(BuildContext context) {
    int currentIndex = navigationShell.currentIndex;

    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      backgroundColor: mainBlue,
      selectedIndex: currentIndex,
      destinations: [
        // ホームボタン
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
            color: currentIndex == 0 ? textDark : textWhite,
          ),
          label: 'Home', // 必須項目
        ),
        // 追加ボタン
        NavigationDestination(
          icon: Icon(
            Icons.add_box_outlined,
            color: currentIndex == 1 ? textDark : textWhite,
          ),
          label: 'Add',
        ),
        // ユーザーサムネ
        NavigationDestination(
          icon: CircleAvatar(
            backgroundImage: AssetImage('assets/images/opanchu_ashiyu.jpg'),
            radius: avaterSizeS,
          ),
          label: 'User',
        ),
        // todo: 開発用ログアウトボタン
        NavigationDestination(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      onDestinationSelected: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
    );
  }
}
