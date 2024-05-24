import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/widgets/group_card.dart';
import 'package:kimikoe_app/ui/widgets/song_card.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GroupCardWide(),
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
    );
  }
}
