import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/screen/appbar/bottom_bar.dart';
import 'package:kimikoe_app/screen/appbar/top_bar.dart';

class AppTopBottomNaviBar extends StatelessWidget {
  const AppTopBottomNaviBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.05;
    return Scaffold(
      appBar: TopBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: navigationShell,
      ),
      // todo: アイコンをタップすると画面遷移
      bottomNavigationBar: BottomBar(
        navigationShell: navigationShell,
      ),
    );
  }
}
