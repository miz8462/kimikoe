import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/screens/appbar/bottom_bar.dart';

class AppTopBottomNaviBar extends StatelessWidget {
  const AppTopBottomNaviBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth * 0.04;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Image(
                image: const AssetImage('assets/images/Kimikoe_Logo.png'),
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20), // 両端の空白
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
            ],
          ),
        ),
        centerTitle: true,
      ),
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
