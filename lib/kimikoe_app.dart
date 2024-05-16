import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/auth/view/sign_in_page.dart';
import 'package:kimikoe_app/ui/post/view/add_artist_page.dart';
import 'package:kimikoe_app/ui/post/view/add_group_page.dart';
import 'package:kimikoe_app/ui/post/view/edit_user_page.dart';

// AppBarとBottomNavigationBarの設計
// bodyに子要素として各ページを受け取る

class KimikoeApp extends StatelessWidget {
  const KimikoeApp({super.key});
  // todo: ログインしてるかどうか
  final bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.05;
    return MaterialApp(
      // 右上の赤いDebugを表示しない
      debugShowCheckedModeBanner: false,
      title: 'キミコエ',
      // ログインしている場合はHomeへ
      // していない場合はサインインへ
      home: (isLogin)
          ? Scaffold(
              appBar: AppBar(
                // leadingウィジェット(左に表示されるウィジェット)のデフォルト幅は56
                leadingWidth: 110,
                leading: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 15.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image(
                      image: const AssetImage('assets/images/Kimikoe_Logo.png'),
                      height: AppBar().preferredSize.height,
                    ),
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Home',
                    style: TextStyle(color: textDark, fontSize: fontLL),
                  ),
                ),
                centerTitle: true,
                // AppBarの下にライン
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1), // 線の高さ
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20), // 両端の空白
                    child: Container(
                      height: 2.0,
                      decoration: BoxDecoration(
                          color: mainBlue.withOpacity(0.3),
                          boxShadow: [
                            BoxShadow(
                              color: mainBlue.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 2,
                            )
                          ]),
                    ),
                  ),
                ),
              ),
              // ログインしている場合はホームへ
              // してない場合はサインインページへ
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: AddArtistPage(),
              ),
              // todo: アイコンをタップすると画面遷移
              bottomNavigationBar: BottomNavigationBar(
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
                        radius: 16,
                      ),
                      label: 'User'),
                ],
              ),
            )
          // ログインしていない場合はサインインへ
          : const Scaffold(body: SignInPage()),
      theme: ThemeData(primaryColor: mainBlue),
    );
  }
}
