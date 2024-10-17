import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/provider/current_user.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({
    super.key,
    required this.navigationShell,
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
      widget.navigationShell.goBranch(addIndex, initialLocation: false);
    });
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
                  '歌詞登録',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addSong);
                  },
                ),
                StyledButton(
                  'グループ登録',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addGroup);
                  },
                ),
                StyledButton(
                  '歌手登録',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addIdol);
                  },
                ),
                StyledButton(
                  '作詞・作曲家登録',
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

  void _signOut() async {
    await supabase.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = widget.navigationShell.currentIndex;

    final userData = ref.watch(userDataProvider);
    final imageUrl =
        userData.value?.map((data) => data).toList()[0]['image_url'];

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: imageUrl == null
          ? const SizedBox()
          : NavigationBar(
              backgroundColor: mainBlue,
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                if (index == addIndex) {
                  _openAddOverlay(context);
                } else if (index == logoutIndex) {
                  _signOut();
                  context.go('/');
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
                    Icons.home_outlined,
                    color: currentIndex == homeIndex ? textDark : textWhite,
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: currentIndex == addIndex ? textDark : textWhite,
                  ),
                  label: 'Add',
                ),
                NavigationDestination(
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl!),
                    radius: avaterSizeS,
                  ),
                  label: 'User',
                ),
                // todo: 開発用ログアウトボタン
                // NavigationDestination(
                //   icon: Icon(Icons.logout),
                //   label: 'SignOut',
                // ),p
              ],
            ),
    );
  }
}
