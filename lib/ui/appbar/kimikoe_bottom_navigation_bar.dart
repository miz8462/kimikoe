import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';

class KimikoeBottomNavigationBar extends StatelessWidget {
  const KimikoeBottomNavigationBar({
    super.key,
  });

  void _logout(BuildContext context) async {
    await supabase.auth.signOut();
    // mountedプロパティをチェックして、ウィジェットがまだマウントされているか確認
    if (!context.mounted) return;
    // ログアウト成功: ログイン画面に遷移する
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      // アイコンのラベルを消去
      // showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 32,
      backgroundColor: mainBlue,
      // todo: 開発用にログアウトのみ実装
      onTap: (int index) {
        if (index == 3) {
          // ここでの3はログアウトアイコンのインデックス
          _logout(context);
        }
      },
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
            backgroundImage: AssetImage('assets/images/opanchu_ashiyu.jpg'),
            radius: avaterSizeS,
          ),
          label: 'User',
        ),
        // ログアウトアイコン
        // todo: 開発用の仮アイコン
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
    );
  }
}
