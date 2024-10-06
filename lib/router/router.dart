// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/user.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/bottom_bar.dart';
import 'package:kimikoe_app/screens/group_detail.dart';
import 'package:kimikoe_app/screens/idol_detail.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/lyric.dart';
import 'package:kimikoe_app/screens/posts/add_artist.dart';
import 'package:kimikoe_app/screens/posts/add_group.dart';
import 'package:kimikoe_app/screens/posts/add_idol.dart';
import 'package:kimikoe_app/screens/posts/add_song.dart';
import 'package:kimikoe_app/screens/posts/edit_user.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:kimikoe_app/screens/song_list.dart';
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
    final currentSession = supabase.auth.currentSession;
    // final currentSession = 'true';
    if (currentSession == null && state.matchedLocation != '/') {
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
                  path: RoutingPath.songList,
                  name: RoutingPath.songList,
                  pageBuilder: (context, state) {
                    final groupData = state.extra as IdolGroup;
                    return MaterialPage(
                      child: SongListScreen(group: groupData),
                      key: state.pageKey,
                    );
                  },
                  routes: [
                    GoRoute(
                        path: RoutingPath.groupDetail,
                        name: RoutingPath.groupDetail,
                        pageBuilder: (context, state) {
                          final groupData = state.extra as IdolGroup;
                          return MaterialPage(
                            child: GroupDetailScreen(group: groupData),
                            key: state.pageKey,
                          );
                        },
                        routes: [
                          GoRoute(
                            path: RoutingPath.idolDetail,
                            name: RoutingPath.idolDetail,
                            pageBuilder: (context, state) {
                              final idolData = state.extra as Idol;
                              return MaterialPage(
                                child: IdolDetailScreen(idol: idolData),
                                key: state.pageKey,
                              );
                            },
                          ),
                        ]),
                  ],
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
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: AddSongScreen(),
                  );
                }),
            GoRoute(
                path: RoutingPath.addGroup,
                name: RoutingPath.addGroup,
                pageBuilder: (context, state) {
                  final Map<String, dynamic>? data;
                  data = state.extra as Map<String, dynamic>?;
                  final IdolGroup? group =
                      data?['group'] ?? IdolGroup(name: '');
                  final bool? isEditing = data?['isEditing'] ?? false;
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: AddGroupScreen(
                      group: group,
                      isEditing: isEditing,
                    ),
                  );
                }),
            GoRoute(
              path: RoutingPath.addIdol,
              name: RoutingPath.addIdol,
              pageBuilder: (context, state) {
                final Map<String, dynamic>? data;
                data = state.extra as Map<String, dynamic>?;
                final Idol? idol = data?['idol'] ?? Idol(name: '');
                final bool? isEditing = data?['isEditing'] ?? false;
                return NoTransitionPage(
                  key: state.pageKey,
                  child: AddIdolScreen(
                    idol: idol,
                    isEditing: isEditing,
                  ),
                );
              },
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
                    final user = state.extra as UserProfile;
                    return MaterialPage(
                      child: EditUserScreen(user: user),
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
