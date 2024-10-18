import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/providers/idol_groups_providere.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/widgets/group_card_l.dart';

class IdolGroupListScreen extends ConsumerWidget {
  const IdolGroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupFuture = ref.watch(idolGroupListFromSupabaseProvider);
    print(groupFuture);
    print(groupFuture.runtimeType);

    return Scaffold(
      appBar: const TopBar(
        imageUrl: 'assets/images/Kimikoe_Logo.png',
        showLeading: false,
      ),
      body: groupFuture.when(
        data: (List<dynamic> groups) {
          if (groups.isEmpty) {
            return const Center(
              child: Text('登録データはありません'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 横に表示する数
              crossAxisSpacing: 18, // 横のスペース
              mainAxisSpacing: 15, // 縦のスペース
              childAspectRatio: 1.0, // カードのアスペクト比
            ),
            itemCount: groups.length,
            itemBuilder: (BuildContext context, int index) {
              // IdolGroupクラスを初期化
              final group = groups[index];
              final imageUrl =
                  fetchPublicImageUrl(group[ColumnName.imageUrl.name]);
              final groupInfo = IdolGroup(
                id: group[ColumnName.id.name],
                name: group[ColumnName.cName.name],
                imageUrl: imageUrl,
                year: group[ColumnName.yearFormingGroups.name],
                comment: group[ColumnName.comment.name],
              );

              return GroupCardL(group: groupInfo);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
