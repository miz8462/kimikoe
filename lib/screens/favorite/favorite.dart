/*
  IdolGroupListScreenを元に作成
*/

import 'package:flutter/material.dart';
import 'package:kimikoe_app/screens/favorite/favorite_groups.dart';
import 'package:kimikoe_app/screens/favorite/favorite_songs.dart';

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
              Tab(text: 'グループ'),
              Tab(text: '曲'),
            ],
          ),
        ),
        body: TabBarView(
          children: [FavoriteGroupsScreen(), FavoriteSongsScreen()],
        ),
      ),
    );
  }
}
