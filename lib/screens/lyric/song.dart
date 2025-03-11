import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/supabase_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/lyric/widget/lyrics.dart';
import 'package:kimikoe_app/screens/lyric/widget/member_color_and_name_list.dart';
import 'package:kimikoe_app/screens/lyric/widget/song_info_card.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_delete.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_fetch.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _memberFuture = fetchGroupMembers(
      widget.group.id!,
      supabase: supabase,
    );

    /*
    youtube_player_iframeパッケージでは
    おそらく文字列の関係(7jEmpp_f_-EというIDの動画)で
    fromVideoIdやcueVideoByUrlなどでは
    自動再生をfalseにできない動画があった。
    そのためloadVideoメソッドを一部使っている。
    */
    final youtubeUrl = widget.song.movieUrl;
    if (youtubeUrl != null && youtubeUrl.isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        params: YoutubePlayerParams(
          showFullscreenButton: true,
        ),
      );

      final params = Uri.parse(youtubeUrl).queryParameters;
      final videoId = params['v'];
      _youtubeController!.cueVideoById(videoId: videoId!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_youtubeController != null) _youtubeController!.close();
  }

  void _deleteSong(BuildContext context) {
    showDialog<Widget>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () async {
            await deleteDataById(
              table: TableName.songs,
              id: widget.song.id.toString(),
              context: context,
              supabase: supabase,
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
              if (_youtubeController != null)
                YoutubePlayerScaffold(
                  controller: _youtubeController!,
                  builder: (context, player) {
                    return Column(
                      children: [player],
                    );
                  },
                ),
              const Gap(spaceM),
              GroupColorAndNameList(group: group, memberFuture: _memberFuture),
              const Gap(spaceS),
              Divider(
                color: mainColor.withValues(alpha: 0.3),
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
