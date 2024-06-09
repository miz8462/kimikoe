import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class KimikoeBottomNavigationBar extends StatelessWidget {
  const KimikoeBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // アイコンのラベルを消去
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 32,
      backgroundColor: mainBlue,
      // アイコン。二つ以上必要。labelは必須
      items: const <BottomNavigationBarItem>[
        // ホームボタン
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: textWhite,
          ),
          label: 'Home', // 必須項目
        ),
        // 追加ボタン
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_box_outlined,
            color: textWhite,
          ),
          label: 'Add',
        ),
        // ユーザーサムネ
        BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/opanchu_ashiyu.jpg'),
              radius: avaterSizeS,
            ),
            label: 'User'),
      ],
    );
  }
}
