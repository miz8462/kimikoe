import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/artist_list_provider.dart';
import 'package:kimikoe_app/providers/groups_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _groupResults = [];
  List<Song> _songResults = [];
  List<Idol> _idolResults = [];

  String? _errorMessage;
  late final SupabaseServices _service;

  @override
  void initState() {
    super.initState();
    _service = ref.read(supabaseServicesProvider);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _groupResults = [];
        _songResults = [];
        _idolResults = [];
        _errorMessage = null;
      });
      return;
    }

    final results = await _service.search.searchAll(query);

    // 曲データをSongオブジェクトに変換
    final songResults = results['songs'] ?? <Map<String, dynamic>>[];
    final songs = await Future.wait(
      songResults.map((song) async {
        logger.d('Processing song: ${song[ColumnName.id]}');
        try {
          final songData = await _service.fetch.fetchSong(song[ColumnName.id]);
          logger.d('songData: $songData');
          final groupId = songData[ColumnName.groupId] as int?;
          final group = groupId != null
              ? ref
                  .read(groupsProvider.notifier)
                  .getGroupById(groupId)
              : null;
          if (group == null && groupId != null) {
            logger.w('グループが見つかりませんでした: groupId=$groupId');
          }

          final composerId = songData[ColumnName.composerId] as int?;
          final composer = composerId != null
              ? ref.read(artistByIdProvider(composerId))
              : null;
          final lyricistId = songData[ColumnName.lyricistId] as int?;
          final lyricist = lyricistId != null
              ? ref.read(artistByIdProvider(lyricistId))
              : null;

          return Song.fromMap(
            songData,
            group: group,
            composer: composer,
            lyricist: lyricist,
          );
        } catch (e) {
          logger.e('曲データの取得に失敗: ${song[ColumnName.id]}', error: e);
          return null;
        }
      }),
    );
    // アイドルデータをIdolオブジェクトに変換
    final idolResults = results['idols'] ?? <Map<String, dynamic>>[];
    final idols = await Future.wait(
      idolResults.map((idol) async {
        try {
          final idolData = await _service.fetch.fetchIdol(idol['id']);
          final groupId = idolData[ColumnName.groupId] as int;
          final groupObj =
              ref.read(groupsProvider.notifier).getGroupById(groupId);
          if (groupObj == null) {
            logger.w('グループが見つかりませんでした: groupId=$groupId');
          }
          return Idol.fromMap(idolData, group: groupObj);
        } catch (e) {
          logger.e('アイドルデータの取得に失敗: ${idol['id']}', error: e);
          return null;
        }
      }),
    );

    setState(() {
      _groupResults = results['groups'] ?? [];
      _songResults = songs.whereType<Song>().toList();
      _idolResults = idols.whereType<Idol>().toList();
      _errorMessage = (_groupResults.isEmpty &&
              _songResults.isEmpty &&
              _idolResults.isEmpty &&
              query.isNotEmpty)
          ? '見つかりません'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        pageTitle: '検索',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ColoredBox(
              color: backgroundLightBlue,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '歌詞、曲名、グループ名、歌手名を入力してください',
                  hintStyle: const TextStyle(color: textGray, fontSize: fontSS),
                  contentPadding: const EdgeInsets.only(left: spaceS),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _search('');
                    },
                  ),
                ),
                onChanged: _search,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // グループ結果
                  if (_groupResults.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spaceS,
                        vertical: 4,
                      ),
                      child: Text(
                        'グループ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ..._groupResults.map((group) {
                    final groupData = ref
                        .read(
                          groupsProvider.notifier,
                        )
                        .getGroupById(group['id']);

                    return ListTile(
                      title: Text(group['name']),
                      onTap: () {
                        context.pushNamed(
                          RoutingPath.songList,
                          extra: groupData,
                        );
                      },
                    );
                  }),
                  // 曲結果
                  if (_songResults.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spaceS,
                        vertical: 4,
                      ),
                      child: Text(
                        '曲',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ..._songResults.map((song) {
                    return ListTile(
                      title: Text(song.title),
                      subtitle:
                          song.group != null ? Text(song.group!.name) : null,
                      onTap: song.group != null
                          ? () {
                              context.pushNamed(
                                RoutingPath.lyric,
                                extra: {
                                  'song': song,
                                  'group': song.group,
                                },
                              );
                            }
                          : null,
                    );
                  }),
                  // 歌手結果
                  if (_idolResults.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spaceS,
                        vertical: 4,
                      ),
                      child: Text(
                        '歌手',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ..._idolResults.map((idol) {
                    return ListTile(
                      title: Text(idol.name),
                      onTap: () {
                        context.pushNamed(
                          RoutingPath.idolDetail,
                          extra: idol,
                        );
                      },
                    );
                  }),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spaceS,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
