import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/groups_provider.dart' show groupsProvider;
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/card/group_card_l.dart';

class IdolGroupListScreen extends ConsumerStatefulWidget {
  const IdolGroupListScreen({super.key});
  @override
  ConsumerState<IdolGroupListScreen> createState() =>
      _IdolGroupListScreenState();
}

class _IdolGroupListScreenState extends ConsumerState<IdolGroupListScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  // グループリストページを開く際、ネットに繋がっていない場合
  // エラーメッセージを表示する。connectivity_plus
  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      logger.e('インターネットに接続されていません');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('インターネットに接続されていません。接続を確認してください'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupsProvider);
    final groups = state.groups;
    final isLoading = state.isLoading;

    late Widget content;
    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (groups.isEmpty) {
      content = const Center(child: Text('登録データはありません'));
    } else {
      content = RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(groupsProvider.notifier)
              .fetchGroupList(supabase: supabase);
        },
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 横に表示する数
            crossAxisSpacing: 18, // 横のスペース
            mainAxisSpacing: 15, // 縦のスペース
          ),itemCount: groups.length,
          itemBuilder: (BuildContext context, int index) {
            final group = groups[index];
            return GroupCardL(group: group);
          },
        ),
      );
    }

    return Scaffold(
      appBar: const TopBar(
        pageTitle: 'グループリスト',
        showLeading: false,
      ),
      body: content,
    );
  }
}
