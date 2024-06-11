import 'package:flutter/material.dart';
import 'package:kimikoe_app/ui/appbar/kimikoe_bottom_navigation_bar.dart';
import 'package:kimikoe_app/ui/appbar/kimikoe_top_app_bar.dart';
import 'package:kimikoe_app/ui/home/view/group_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.05;
    return Scaffold(
      appBar: KimikoeTopAppBar(),
      // ログインしている場合はホームへ
      // してない場合はサインインページへ
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        // todo: メイン画面は操作により変化する
        child: GroupListPage(),
      ),
      // todo: アイコンをタップすると画面遷移
      bottomNavigationBar: KimikoeBottomNavigationBar(),
    );
  }
}
