import 'package:flutter/material.dart';
import 'package:kimikoe_app/ui/widgets/group_card.dart';

/*
グループ一覧を表示する
画面上はグリッドで横2列、縦4行（？）
下方にスクロールしてさらにグループを表示
各グループをカードで画像と名前を表示する
*/

class GroupListPage extends StatelessWidget {
  const GroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 横に表示する数
        crossAxisSpacing: 18, // 横のスペース
        mainAxisSpacing: 15, // 縦のスペース
        childAspectRatio: 1.0, // カードのアスペクト比
      ),
      // itemCount: 8, // todo: 取得したデータ数
      itemBuilder: (BuildContext context, int index) {
        return GroupCard();
      },
    );
  }
}
