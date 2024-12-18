import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/providers/song_list_provider.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/card/group_card_m.dart';
import 'package:kimikoe_app/widgets/card/song_card.dart';

class SongListScreen extends ConsumerStatefulWidget {
  const SongListScreen({
    required this.group,
    super.key,
  });
  final IdolGroup group;

  @override
  ConsumerState<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends ConsumerState<SongListScreen> {
  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final songsList = ref.watch(songListOfGroupProvider(group.id!));

    return Scaffold(
      appBar: const TopBar(
        pageTitle: 'ソングリスト',
      ),
      body: Padding(
        padding: screenPadding,
        child: Column(
          children: [
            const Gap(spaceS),
            GroupCardM(group: group),
            const Gap(spaceM),
            Expanded(
              child: songsList.when(
                data: (songs) {
                  return ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (ctx, index) {
                      return SongCard(
                        song: songs[index],
                        group: group,
                      );
                    },
                  );
                },
                error: (error, _) {
                  logger.e('曲の取得に失敗しました: $error');
                  return Center(
                    child: Text('曲の取得に失敗しました。再度お試しください。'),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
