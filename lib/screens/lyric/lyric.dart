import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/lyric/widget/lyrics.dart';
import 'package:kimikoe_app/screens/lyric/widget/member_color_and_name_list.dart';
import 'package:kimikoe_app/screens/lyric/widget/song_info_card.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';

// HylightedTextクラスを作成し行単位でハイライトできるようにする
// 文字が見やすい用に色を調節

class LyricScreen extends StatefulWidget {
  const LyricScreen({
    super.key,
    required this.song,
    required this.group,
  });
  final IdolGroup group;
  final Song song;

  @override
  State<LyricScreen> createState() => _LyricScreenState();
}

class _LyricScreenState extends State<LyricScreen> {
  late Future<List<Map<String, dynamic>>> _memberFuture;
  @override
  void initState() {
    super.initState();
    _memberFuture = fetchGroupMembers(widget.group.id!);
  }

  void _deleteSong(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () {
            deleteDataFromTable(
              table: TableName.songs.name,
              column: ColumnName.id.name,
              value: (widget.song.id).toString(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = true;
    final song = widget.song;
    final group = widget.group;
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
              GroupColorAndNameList(group: group, memberFuture: _memberFuture),
              Gap(spaceLL),
              Lyrics(
                memberFuture: _memberFuture,
                lyrics: song.lyrics,
              ),
              Gap(spaceM),
            ],
          ),
        ),
      ),
    );
  }
}
