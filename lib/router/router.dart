import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/ui/appbar/app_top_bottom_navi_bar.dart';
import 'package:kimikoe_app/ui/auth/view/sign_in_page.dart';
import 'package:kimikoe_app/ui/group/view/group_page.dart';
import 'package:kimikoe_app/ui/home/view/home_page.dart';
import 'package:kimikoe_app/ui/lyric/lyric_page.dart';
import 'package:kimikoe_app/ui/post/view/add_artist_page.dart';
import 'package:kimikoe_app/ui/post/view/add_group_page.dart';
import 'package:kimikoe_app/ui/post/view/add_member_page.dart';
import 'package:kimikoe_app/ui/post/view/add_song_page.dart';
import 'package:kimikoe_app/ui/post/view/edit_user_page.dart';
import 'package:kimikoe_app/ui/user/view/user_page.dart';
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
  // todo: マジックリンクで戻ってきたとき遷移しない
  redirect: (context, state) {
    final currentSession = supabase.auth.currentSession;
    // final currentSession = 'true';
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
      builder: (cotext, state) => SignInPage(),
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
                child: HomePage(),
              ),
              routes: [
                GoRoute(
                  path: 'group-page',
                  name: 'group-page',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      child: GroupPage(),
                      key: state.pageKey,
                    );
                  },
                ),
                GoRoute(
                  path: 'lyric-page',
                  name: 'lyric-page',
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
              name: 'add-song',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddSongPage(),
              ),
            ),
            GoRoute(
              path: '/add-group',
              name: 'add-group',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddGroupPage(),
              ),
            ),
            GoRoute(
              path: '/add-member',
              name: 'add-member',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: AddMemberPage(),
              ),
            ),
            GoRoute(
              path: '/add-artist',
              name: 'add-artist',
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
              name: 'user-info',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: UserPage(),
              ),
              routes: [
                GoRoute(
                  path: 'edit-user',
                  name: 'edit-user',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      child: EditUserPage(),
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
                child: SignInPage(),
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
