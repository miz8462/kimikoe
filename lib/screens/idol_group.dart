import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/group_info.dart';
import 'package:kimikoe_app/screens/widgets/song_card.dart';

class IdolGroupScreen extends StatefulWidget {
  const IdolGroupScreen({
    super.key,
    required this.group,
  });
  final IdolGroup group;

  @override
  State<IdolGroupScreen> createState() => _IdolGroupScreenState();
}

class _IdolGroupScreenState extends State<IdolGroupScreen> {
  late Future _songListFuture;

  @override
  void initState() {
    super.initState();
    _loadSongList();
  }

  void _loadSongList() {
    _songListFuture = supabase
        .from(TableName.songs.name)
        .select()
        .eq(ColumnName.groupId.colname, widget.group.id!);
  }

  @override
  Widget build(BuildContext context) {
    // todo: グループidから曲のリストを取得する。それをマップしSongCardに表示する
    return Scaffold(
      appBar: TopBar(
        title: 'ソングリスト',
      ),
      body: Padding(
        padding: screenPadding,
        child: Column(
          children: [
            GroupInfo(group: widget.group),
            const Gap(spaceWidthM),
            Expanded(
              child: FutureBuilder(
                future: _songListFuture,
                builder: (ctx, snapshot) {
                  print(snapshot.data);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data.toString().length == 2) {
                    return Center(child: Text('登録データはありません'));
                  }
                  final songList = snapshot.data!;
                  print(songList);
                  return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                    return SongCard();
                    // return SongCard(songData: songList[index]);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
