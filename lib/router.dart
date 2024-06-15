import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/ui/appbar/app_top_bottom_navi_bar.dart';
import 'package:kimikoe_app/ui/group/view/group_page.dart';
import 'package:kimikoe_app/ui/home/view/home_page.dart';
import 'package:kimikoe_app/ui/lyric/lyric_page.dart';
import 'package:kimikoe_app/ui/post/view/add_artist_page.dart';
import 'package:kimikoe_app/ui/post/view/add_group_page.dart';
import 'package:kimikoe_app/ui/post/view/add_member_page.dart';
import 'package:kimikoe_app/ui/post/view/add_song_page.dart';
import 'package:kimikoe_app/ui/user/view/user_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _addItemNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'add-item');
final _userInfoNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'user-info');

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    // GoRoute(
    //   path: '/signin',
    //   name: 'signin',
    //   builder: (cotext, state) => SignInPage(),
    // ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state, navitationShell) {
        return AppTopBottomNaviBar(navigationShell: navitationShell);
      },
      branches: [
        // home
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: HomePage(),
              ),
              routes: [
                GoRoute(
                  path: 'group-page',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      child: GroupPage(),
                      key: state.pageKey,
                    );
                  },
                ),
                GoRoute(
                  path: 'lyric-page',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      child: LyricPage(),
                      key: state.pageKey,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _addItemNavigatorKey,
          routes: [
            GoRoute(
              path: '/add-song',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddSongPage(),
              ),
            ),
            GoRoute(
              path: '/add-group',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddGroupPage(),
              ),
            ),
            GoRoute(
              path: '/add-member',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddMemberPage(),
              ),
            ),
            GoRoute(
              path: '/add-artist',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddArtistPage(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _userInfoNavigatorKey,
          routes: [
            GoRoute(
              path: '/user-info',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: UserPage(),
              ),
            )
          ],
        ),
      ],
    ),
  ],
);
