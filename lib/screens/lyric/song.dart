import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
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

class SongScreen extends StatefulWidget {
  const SongScreen({
    super.key,
    required this.song,
    required this.group,
  });
  final IdolGroup group;
  final Song song;

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
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
    const bool isEditing = true;
    final song = widget.song;
    final group = widget.group;
    final data = {
      'song': song,
      'isEditing': isEditing,
    };
    return Scaffold(
      appBar: TopBar(
        pageTitle: song.title,
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
              const Gap(spaceM),
              SongInfoCard(song: song),
              const Gap(spaceM),
              GroupColorAndNameList(group: group, memberFuture: _memberFuture),
              const Gap(spaceS),
              Divider(
                color: mainColor.withOpacity(0.3),
                thickness: 2,
              ),
              const Gap(spaceS),
              Lyrics(
                memberFuture: _memberFuture,
                lyrics: song.lyrics,
              ),
              const Gap(spaceM),
            ],
          ),
        ),
      ),
    );
  }
}
