import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

/*
グループ一覧を表示する
画面上はグリッドで横2列、縦4行（？）
下方にスクロールしてさらにグループを表示
各グループをカードで画像と名前を表示する
*/

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
      ),
      // itemCount: 8, // 外部から取得したデータを表示
      itemBuilder: (BuildContext context, int index) {
        return GroupCard();
      },
    );
  }
}

// グループ画像とグループ名を受け取るカード
class GroupCard extends StatelessWidget {
  const GroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image(
            image: AssetImage('assets/images/poison_palette.jpg'),
          ),
          Text(
            'Poison Palette',
            style: TextStyle(
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }
}
