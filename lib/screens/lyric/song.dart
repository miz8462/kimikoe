import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/lyric/widget/lyrics.dart';
import 'package:kimikoe_app/screens/lyric/widget/member_color_and_name_list.dart';
import 'package:kimikoe_app/screens/lyric/widget/song_info_card.dart';
import 'package:kimikoe_app/services/supabase_service.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';

// HylightedTextクラスを作成し行単位でハイライトできるようにする
// 文字が見やすい用に色を調節

class SongScreen extends StatefulWidget {
  const SongScreen({
    required this.song,
    required this.group,
    super.key,
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
    _memberFuture = fetchGroupMembers(widget.group.id!, supabase);
  }

  void _deleteSong(BuildContext context) {
    showDialog<Widget>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () async {
            await deleteDataFromTable(
              table: TableName.songs,
              column: ColumnName.id,
              value: widget.song.id.toString(),
              context: context,
            );
          },
          successMessage: '${widget.song.title}が削除されました',
          errorMessage: '${widget.song.title}の削除に失敗しました',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const isEditing = true;
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
