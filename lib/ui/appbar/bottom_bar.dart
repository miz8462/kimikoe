import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/widgets/styled_button.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    required this.navigationShell,
    super.key,
  });
  final StatefulNavigationShell navigationShell;

  void _openAddOverlay(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StyledButton(
                  'Add Song',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/add-song');
                  },
                  // child: Text('Add Song'),
                ),
                StyledButton(
                  'Add Group',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/add-group');
                  },
                ),
                StyledButton(
                  'Add Member',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/add-member');
                  },
                ),
                StyledButton(
                  'Add Artist',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/add-artist');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // void _logout() async {}

  @override
  Widget build(BuildContext context) {
    int currentIndex = navigationShell.currentIndex;
    int addIndex = 1;
    return NavigationBar(
      backgroundColor: mainBlue,
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        if (index == addIndex) {
          _openAddOverlay(context);
        } else {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        }
      },
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
    );
  }
}
