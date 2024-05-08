import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/auth/view/sign_in_page.dart';
import 'package:kimikoe_app/ui/home/view/home_page.dart';

// AppBarとBottomNavigationBarの設計
// bodyに子要素として各ページを受け取る

class KimikoeApp extends StatelessWidget {
  const KimikoeApp({super.key});
  final bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上の赤いDebugを表示しない
      debugShowCheckedModeBanner: false,
      title: 'キミコエ',
      // ログインしている場合はHomeへ
      // していない場合はAuthへ
      home: (isLogin)
          ? Scaffold(
              appBar: AppBar(
                // leadingウィジェットのデフォルト幅は56
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
              body: HomePage(),
              bottomNavigationBar: BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                iconSize: 32,
                backgroundColor: mainBlue,
                
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: textWhite,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_box_outlined,
                      color: textWhite,
                    ),
                    label: 'Add',
                  ),
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
          : SignInPage(),
      theme: ThemeData(primaryColor: mainBlue),
    );
  }
}
