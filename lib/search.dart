import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/providers/groups_provider.dart';
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
  List<Map<String, dynamic>> _songResults = [];
  List<Map<String, dynamic>> _idolResults = [];

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
    setState(() {
      _groupResults = results['groups'] ?? [];
      _songResults = results['songs'] ?? [];
      _idolResults = results['idols'] ?? [];

      _errorMessage =
          (_groupResults.isEmpty && _songResults.isEmpty && query.isNotEmpty)
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
                      title: Text(song['title']),
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
                      title: Text(idol['name']),
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
