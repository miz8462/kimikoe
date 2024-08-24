// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/bottom_bar.dart';
import 'package:kimikoe_app/screens/idol_group.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/lyric.dart';
import 'package:kimikoe_app/screens/post/add_artist.dart';
import 'package:kimikoe_app/screens/post/add_group.dart';
import 'package:kimikoe_app/screens/post/add_member.dart';
import 'package:kimikoe_app/screens/post/add_song.dart';
import 'package:kimikoe_app/screens/post/edit_user.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:kimikoe_app/screens/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: RoutingPath.groupList);
final _addItemNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'add-item');
final _userInfoNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'user-info');
final _signOutNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sign-out');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
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
      return '/group_list';
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
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navitationShell) {
        return BottomBar(navigationShell: navitationShell);
      },
      branches: [
        // home
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: RoutingPath.groupList,
              name: RoutingPath.groupList,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: IdolGroupListScreen(),
              ),
              routes: [
                GoRoute(
                  path: RoutingPath.groupDetails,
                  name: RoutingPath.groupDetails,
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      child: IdolGroupScreen(),
                      key: state.pageKey,
                    );
                  },
                ),
                GoRoute(
                  path: RoutingPath.lyric,
                  name: RoutingPath.lyric,
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
              path: RoutingPath.addSong,
              name: RoutingPath.addSong,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddSongScreen(),
              ),
            ),
            GoRoute(
              path: RoutingPath.addGroup,
              name: RoutingPath.addGroup,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddGroupScreen(),
              ),
            ),
            GoRoute(
              path: RoutingPath.addMember,
              name: RoutingPath.addMember,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddMemberScreen(),
              ),
            ),
            GoRoute(
              name: RoutingPath.addArtist,
              path: RoutingPath.addArtist,
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
              path: RoutingPath.userDetails,
              name: RoutingPath.userDetails,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: UserScreen(),
              ),
              routes: [
                GoRoute(
                  path: RoutingPath.editUser,
                  name: RoutingPath.editUser,
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
              path: RoutingPath.signOut,
              name: RoutingPath.signOut,
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
