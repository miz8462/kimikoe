import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/home/view/home_page.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GroupCard(),
        Column(
          children: [
            SongCard(),
            SongCard(),
            SongCard(),
          ],
        )
      ],
    );
  }
}

class SongCard extends StatelessWidget {
  const SongCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card();
  }
}


