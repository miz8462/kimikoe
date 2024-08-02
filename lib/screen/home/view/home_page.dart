import 'package:flutter/material.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/widgets/group_card.dart';

/*
グループ一覧を表示する
画面上はグリッドで横2列、縦4行（？）
下方にスクロールしてさらにグループを表示
各グループをカードで画像と名前を表示する
*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = supabase.from('group').select('name, image_url');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final groups = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 横に表示する数
            crossAxisSpacing: 18, // 横のスペース
            mainAxisSpacing: 15, // 縦のスペース
            childAspectRatio: 1.0, // カードのアスペクト比
          ),
          itemCount: groups.length, // todo: 取得したデータ数
          itemBuilder: (BuildContext context, int index) {
            final group = groups[index];
            var imageUrl = group['image_url'];
            imageUrl ??= "";
            return GroupCard(
              name: group['name'],
              imageUrl: imageUrl,
            );
          },
        );
      },
    );
  }
}
