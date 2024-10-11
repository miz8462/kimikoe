import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/lyric/widget/member_color_and_name_list.dart';
import 'package:kimikoe_app/screens/lyric/widget/song_info_card.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';
import 'package:kimikoe_app/widgets/highlighted_text.dart';

// HylightedTextクラスを作成し行単位でハイライトできるようにする
// 文字が見やすい用に色を調節

class LyricScreen extends StatelessWidget {
  const LyricScreen({
    super.key,
    required this.song,
    required this.group,
  });
  final IdolGroup group;
  final Song song;

  void _deleteSong(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () {
            deleteDataFromTable(
              table: TableName.songs.name,
              column: ColumnName.id.name,
              value: (song.id).toString(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = true;
    final data = {
      'song': song,
      'isEditing': isEditing,
    };
    return Scaffold(
      appBar: TopBar(
        title: song.title,
        isEditing: isEditing,
        editRoute: RoutingPath.addSong,
        delete: () {
          _deleteSong(context);
        },
        data: data,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(spaceM),
              SongInfoCard(song: song),
              Gap(spaceM),
              GroupColorAndNameList(
                group: group,
              ),
              Gap(spaceL),
              // 歌詞
              Column(
                children: [
                  HighlightedText(
                    'miuちゃん、大好き',
                    highlightColor: Color.fromARGB(78, 79, 195, 241),
                  ),
                ],
              ),
              Gap(spaceM),
            ],
          ),
        ),
      ),
    );
  }
}
