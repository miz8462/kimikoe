// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/screens/appbar/app_top_bottom_navi_bar.dart';
import 'package:kimikoe_app/screens/group.dart';
import 'package:kimikoe_app/screens/group_list.dart';
import 'package:kimikoe_app/screens/lyric.dart';
import 'package:kimikoe_app/screens/post/add_artist.dart';
import 'package:kimikoe_app/screens/post/add_group.dart';
import 'package:kimikoe_app/screens/post/add_member.dart';
import 'package:kimikoe_app/screens/post/add_song.dart';
import 'package:kimikoe_app/screens/post/edit_user.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:kimikoe_app/screens/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _addItemNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'add-item');
final _userInfoNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'user-info');
final _signOutNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sign-out');

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  redirect: (context, state) {
    // todo: 開発用自動ログイン
    // final currentSession = supabase.auth.currentSession;
    final currentSession = 'true';
    if (currentSession == null && state.matchedLocation != '/') {
      // if (false) {
      return '/';
    } else if (currentSession != null && state.matchedLocation == '/') {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'signin',
      builder: (cotext, state) => SignInScreen(),
    ),
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
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: GroupListScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'group-page',
                  name: 'group-page',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      child: GroupScreen(),
                      key: state.pageKey,
                    );
                  },
                ),
                GoRoute(
                  path: 'lyric-page',
                  name: 'lyric-page',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      child: LyricScreen(),
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
              name: 'add-song',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddSongScreen(),
              ),
            ),
            GoRoute(
              path: '/add-group',
              name: 'add-group',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddGroupScreen(),
              ),
            ),
            GoRoute(
              path: '/add-member',
              name: 'add-member',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddMemberScreen(),
              ),
            ),
            GoRoute(
              path: '/add-artist',
              name: 'add-artist',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddArtistScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _userInfoNavigatorKey,
          routes: [
            GoRoute(
              path: '/user-info',
              name: 'user-info',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: UserScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'edit-user',
                  name: 'edit-user',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      child: EditUserScreen(),
                      key: state.pageKey,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        // todo: 開発用ログアウトボタン
        StatefulShellBranch(
          navigatorKey: _signOutNavigatorKey,
          routes: [
            GoRoute(
              path: '/sign-out',
              name: 'sign-out',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: SignInScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

class AuthState {
  final Session? session;
  AuthState({this.session});

  factory AuthState.initial() {
    return AuthState(session: supabase.auth.currentSession);
  }
}
