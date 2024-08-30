import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.navigationShell,
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int homeIndex = 0;
  int addIndex = 1;
  int userIndex = 2;
  int logoutIndex = 3;

  var _isSending = false;

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
                  'Add Song',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addSong);
                  },
                  isSending: _isSending,

                  // child: Text('Add Song'),
                ),
                StyledButton(
                  'Add Group',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addGroup);
                  },
                  isSending: _isSending,
                ),
                StyledButton(
                  'Add Idol',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addMember);
                  },
                  isSending: _isSending,
                ),
                StyledButton(
                  'Add Artist',
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(RoutingPath.addArtist);
                  },
                  isSending: _isSending,
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
    double screenWidth = MediaQuery.of(context).size.width;

    int currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
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
              backgroundImage: AssetImage('assets/images/opanchu_ashiyu.jpg'),
              radius: avaterSizeS,
            ),
            label: 'User',
          ),
          // todo: 開発用ログアウトボタン
          NavigationDestination(
            icon: Icon(Icons.logout),
            label: 'SignOut',
          ),
        ],
      ),
    );
  }
}
