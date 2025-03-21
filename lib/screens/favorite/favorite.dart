/*
  IdolGroupListScreenを元に作成
*/

import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/screens/favorite/favorite_groups.dart';
import 'package:kimikoe_app/screens/favorite/favorite_songs.dart';
import 'package:kimikoe_app/widgets/text/styled_text.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(
                key: Key(WidgetKeys.groupTab),
                child: StyledText(
                  'グループ',
                  fontSize: fontM,
                  textColor: mainColor,
                ),
              ),
              Tab(
                key: Key(WidgetKeys.songTab),
                child: StyledText(
                  '曲',
                  fontSize: fontM,
                  textColor: mainColor,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FavoriteGroupsScreen(),
            FavoriteSongsScreen(),
          ],
        ),
      ),
    );
  }
}
