import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/group_card_m.dart';
import 'package:kimikoe_app/widgets/song_card.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen({
    super.key,
    required this.group,
  });
  final IdolGroup group;

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late Future _songListFuture;
  late IdolGroup _group;
  @override
  void initState() {
    super.initState();
    _loadSongList();
  }

  void _loadSongList() {
    _songListFuture = supabase
        .from(TableName.songs.name)
        .select()
        .eq(ColumnName.groupId.name, widget.group.id!);
  }

  @override
  Widget build(BuildContext context) {
    _group = widget.group;

    return Scaffold(
      appBar: const TopBar(
        title: 'ソングリスト',
      ),
      body: Padding(
        padding: screenPadding,
        child: Column(
          children: [
            const Gap(spaceS),
            GroupCardM(group: _group),
            const Gap(spaceM),
            Expanded(
              child: FutureBuilder(
                future: _songListFuture,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data.toString().length == 2) {
                    return const Center(child: Text('登録データはありません'));
                  }
                  final songList = snapshot.data! as List;
                  return ListView.builder(
                    itemCount: songList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SongCard(
                        songData: songList[index],
                        group: _group,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
