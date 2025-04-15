import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/song.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/providers/favorite/favorite_provider.dart';
import 'package:kimikoe_app/providers/supabase/supabase_services_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/lyric/widget/lyrics.dart';
import 'package:kimikoe_app/screens/lyric/widget/member_color_and_name_list.dart';
import 'package:kimikoe_app/screens/lyric/widget/song_info_card.dart';
import 'package:kimikoe_app/utils/scroll_utils.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// HylightedTextクラスを作成し行単位でハイライトできるようにする
// 文字が見やすい用に色を調節

class SongScreen extends ConsumerStatefulWidget {
  const SongScreen({
    required this.song,
    required this.group,
    super.key,
  });
  final IdolGroup group;
  final Song song;

  @override
  ConsumerState<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends ConsumerState<SongScreen> {
  late Future<List<Map<String, dynamic>>> _memberFuture;
  YoutubePlayerController? _youtubeController;
  var _isStarred = false;

  final _scrollController = ScrollController();
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    final service = ref.read(supabaseServicesProvider);
    _memberFuture = service.fetch.fetchGroupMembers(
      widget.group.id!,
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
    _scrollController.dispose();
  }

  void _deleteSong(BuildContext context) {
    showDialog<Widget>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () async {
            final service = ref.read(supabaseServicesProvider);
            await service.delete.deleteDataById(
              table: TableName.songs,
              id: widget.song.id.toString(),
              context: context,
            );
          },
          successMessage: '${widget.song.title}が削除されました',
          errorMessage: '${widget.song.title}の削除に失敗しました',
        );
      },
    );
  }

  void _toggleStarred() {
    final id = widget.song.id;
    if (id == null) return;

    final notifier =
        ref.read(favoriteNotifierProvider(FavoriteType.songs).notifier);

    setState(() {
      _isStarred = !_isStarred;
    });

    if (_isStarred) {
      notifier.add(id);
    } else {
      notifier.remove(id);
    }
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

    // 横画面の時youtubeplayer意外を表示しない
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (isLandscape) {
      return YoutubePlayerScaffold(
        controller: _youtubeController!,
        builder: (context, player) {
          return Column(
            children: [
              player,
            ],
          );
        },
      );
    }

    final favoriteSongsAsync = ref.watch(
      favoriteNotifierProvider(FavoriteType.songs),
    );

    return Scaffold(
      appBar: favoriteSongsAsync.when(
        data: (favoriteSongs) {
          // お気に入り状態を最新に保つ（必要なら）
          final isCurrentlyStarred = favoriteSongs.contains(song.id);
          if (_isStarred != isCurrentlyStarred) {
            setState(() {
              _isStarred = isCurrentlyStarred;
            });
          }
          return TopBar(
            pageTitle: song.title,
            isEditing: isEditing,
            editRoute: RoutingPath.addSong,
            delete: () {
              _deleteSong(context);
            },
            data: data,
            isStarred: _isStarred,
            hasFavoriteFeature: true,
            onStarToggle: _toggleStarred,
          );
        },
        loading: () => TopBar(
          pageTitle: song.title,
          isEditing: isEditing,
          editRoute: RoutingPath.addSong,
          delete: () {
            _deleteSong(context);
          },
          data: data,
          isStarred: _isStarred,
          hasFavoriteFeature: true,
        ),
        error: (error, stack) => TopBar(
          pageTitle: song.title,
          isEditing: isEditing,
          editRoute: RoutingPath.addSong,
          delete: () {
            _deleteSong(context);
          },
          data: data,
          isStarred: _isStarred,
          hasFavoriteFeature: true,
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (ScrollUtils.handleScrollNotification(
            notification,
            ref,
            lastScrollOffset: _lastScrollOffset,
          )) {
            setState(() {
              _lastScrollOffset = notification.metrics.pixels;
            });
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
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
                        children: [
                          player,
                        ],
                      );
                    },
                  ),
                const Gap(spaceM),
                GroupColorAndNameList(
                  group: group,
                  memberFuture: _memberFuture,
                ),
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
      ),
    );
  }
}
