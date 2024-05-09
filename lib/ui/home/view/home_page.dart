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
    // // 画面の両端を空白にする
    // // 画面の幅を取得
    // double screenWidth = MediaQuery.of(context).size.width;
    // // 画面の幅に基づいて4%の空白を計算
    // double sidePadding = screenWidth * 0.04;
    // return Padding(
    //   padding: EdgeInsets.symmetric(horizontal: sidePadding),
    //   child: GridView.builder(
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),  
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

// グループ画像とグループ名を受け取るカード
class GroupCard extends StatelessWidget {
  const GroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // 影の色
            offset: Offset(4, 4), // 右下方向に影をオフセット
            blurRadius: 5, // 影のぼかしの大きさ
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 画像をClipRRectで囲って角を丸くする
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage('assets/images/poison_palette.jpg'),
            ),
          ),
          Text(
            'Poison Palette',
            textAlign: TextAlign.start,
            style: TextStyle(
              color: textDark,
            ),
          ),
        ],
      ),
    );
  }
}
