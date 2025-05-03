// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/bottom_bar.dart';
import 'package:kimikoe_app/screens/favorite/favorite.dart';
import 'package:kimikoe_app/screens/group_detail/group_detail.dart';
import 'package:kimikoe_app/screens/idol_detail.dart';
import 'package:kimikoe_app/screens/idol_group_list.dart';
import 'package:kimikoe_app/screens/lyric/song.dart';
import 'package:kimikoe_app/screens/posts/add_artist.dart';
import 'package:kimikoe_app/screens/posts/add_group.dart';
import 'package:kimikoe_app/screens/posts/add_idol.dart';
import 'package:kimikoe_app/screens/posts/add_song.dart';
import 'package:kimikoe_app/screens/posts/edit_user.dart';
import 'package:kimikoe_app/screens/search.dart';
import 'package:kimikoe_app/screens/sign_in.dart';
import 'package:kimikoe_app/screens/song_list.dart';
import 'package:kimikoe_app/screens/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: RoutingPath.groupList);
final _favoriteNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'favorite');
final _searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _addItemNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'add-item');
final _userInfoNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'user-info');

GoRouter createRouter(SupabaseClient supabase) {
  final session = supabase.auth.currentSession;
  final initialRoute = session != null ? '/group_list' : '/';
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: initialRoute,
    redirect: (context, state) {
      final currentSession = supabase.auth.currentSession;
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
        builder: (cotext, state) => const SignInScreen(),
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
                  child: const IdolGroupListScreen(),
                ),
                routes: [
                  GoRoute(
                    path: RoutingPath.songList,
                    name: RoutingPath.songList,
                    pageBuilder: (context, state) {
                      final groupData = state.extra! as IdolGroup;
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
                          final groupData = state.extra! as IdolGroup;
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
                              final idolData = state.extra! as Idol;
                              return MaterialPage(
                                child: IdolDetailScreen(idol: idolData),
                                key: state.pageKey,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: RoutingPath.lyric,
                    name: RoutingPath.lyric,
                    pageBuilder: (context, state) {
                      final Map<String, dynamic> data;
                      data = state.extra! as Map<String, dynamic>;
                      final song = data['song'] as Song;
                      final group = data['group'] as IdolGroup;
                      return MaterialPage(
                        child: SongScreen(song: song, group: group),
                        key: state.pageKey,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // お気に入り
          StatefulShellBranch(
            navigatorKey: _favoriteNavigatorKey,
            routes: [
              GoRoute(
                path: RoutingPath.favorite,
                name: RoutingPath.favorite,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const FavoriteScreen(),
                ),
              ),
            ],
          ),
          // 検索
          StatefulShellBranch(
            navigatorKey: _searchNavigatorKey,
            routes: [
              GoRoute(
                path: RoutingPath.search,
                name: RoutingPath.search,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const SearchScreen(),
                ),
              ),
            ],
          ),
          // 追加
          StatefulShellBranch(
            navigatorKey: _addItemNavigatorKey,
            routes: [
              GoRoute(
                path: RoutingPath.addSong,
                name: RoutingPath.addSong,
                pageBuilder: (context, state) {
                  // TODO: 編集時のdata
                  final Map<String, dynamic>? data;
                  data = state.extra as Map<String, dynamic>?;
                  final song = data?['song'] ??
                      const Song(title: '', lyrics: '', imageUrl: noImage);
                  final isEditing = data?['isEditing'] ?? false;
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: AddSongScreen(
                      song: song,
                      isEditing: isEditing,
                    ),
                  );
                },
              ),
              GoRoute(
                path: RoutingPath.addGroup,
                name: RoutingPath.addGroup,
                pageBuilder: (context, state) {
                  final Map<String, dynamic>? data;
                  data = state.extra as Map<String, dynamic>?;
                  final group = data?['group'] ??
                      const IdolGroup(name: '', imageUrl: noImage);
                  final isEditing = data?['isEditing'] ?? false;
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: AddGroupScreen(
                      group: group,
                      isEditing: isEditing,
                    ),
                  );
                },
              ),
              GoRoute(
                path: RoutingPath.addIdol,
                name: RoutingPath.addIdol,
                pageBuilder: (context, state) {
                  final Map<String, dynamic>? data;
                  data = state.extra as Map<String, dynamic>?;
                  final idol = data?['idol'];
                  final isEditing = data?['isEditing'] ?? false;
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
                  child: const AddArtistScreen(),
                ),
              ),
            ],
          ),
          // ユーザー
          StatefulShellBranch(
            navigatorKey: _userInfoNavigatorKey,
            routes: [
              GoRoute(
                path: RoutingPath.userDetails,
                name: RoutingPath.userDetails,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const UserScreen(),
                ),
                routes: [
                  GoRoute(
                    path: RoutingPath.editUser,
                    name: RoutingPath.editUser,
                    pageBuilder: (context, state) {
                      final Map<String, dynamic>? data;
                      data = state.extra as Map<String, dynamic>?;
                      final isEditing = data?['isEditing'] ?? false;
                      return MaterialPage(
                        child: EditUserScreen(
                          isEditing: isEditing!,
                        ),
                        key: state.pageKey,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
