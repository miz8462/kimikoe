import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/group_info.dart';
import 'package:kimikoe_app/screens/widgets/song_card.dart';

class IdolGroupScreen extends StatelessWidget {
  const IdolGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'ソングリスト',
      ),
      body: Padding(
        padding: screenPadding,
        child: Column(
          children: [
            const GroupInfo(),
            const Gap(spaceWidthM),
            Expanded(
              child: ListView(
                children: const [
                  SongCard(),
                  Gap(spaceWidthSS),
                  SongCard(),
                  Gap(spaceWidthSS),
                  SongCard(),
                  Gap(spaceWidthSS),
                  SongCard(),
                  Gap(spaceWidthSS),
                  SongCard(),
                  Gap(spaceWidthSS),
                  SongCard(),
                  Gap(spaceWidthSS),
                  SongCard(),
                  Gap(spaceWidthSS),
                  SongCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
