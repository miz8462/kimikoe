import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/providers/idol_group_list_providere.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/group_card_l.dart';

class IdolGroupListScreen extends ConsumerWidget {
  const IdolGroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idolGroupList = ref.watch(idolGroupListProvider);
    final isLoading = ref.watch(idolGroupListProvider.notifier).isLoading;
    late Widget content;
    if (isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (idolGroupList.isEmpty) {
      content = const Center(child: Text('登録データはありません'));
    } else {
      content = RefreshIndicator(
        onRefresh: () async {
          await ref.read(idolGroupListProvider.notifier).fetchGroupList();
        },
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 横に表示する数
            crossAxisSpacing: 18, // 横のスペース
            mainAxisSpacing: 15, // 縦のスペース
            childAspectRatio: 1.0, // カードのアスペクト比
          ),
          itemCount: idolGroupList.length,
          itemBuilder: (BuildContext context, int index) {
            final groupInfo = idolGroupList[index];
            return GroupCardL(group: groupInfo);
          },
        ),
      );
    }

    return Scaffold(
      appBar: const TopBar(
        imageUrl: 'assets/images/Kimikoe_Logo.png',
        showLeading: false,
      ),
      body: content,
    );
  }
}
