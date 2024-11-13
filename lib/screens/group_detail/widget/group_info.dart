import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/utils/open_links.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo({super.key, required this.group});
  final IdolGroup group;

  @override
  Widget build(BuildContext context) {
    Uri? officialUrl;
    if (group.officialUrl != null && group.officialUrl!.isNotEmpty) {
      officialUrl = Uri.parse(group.officialUrl!);
    }

    Uri? twitterWebUrl;
    Uri? twitterDeepLinkUrl;
    if (group.twitterUrl != null && group.twitterUrl!.isNotEmpty) {
      twitterWebUrl = Uri.parse(group.twitterUrl!);
      final twitterUserName = twitterWebUrl.pathSegments.last;
      twitterDeepLinkUrl = Uri.parse('$twitterScheme$twitterUserName');
    }

    Uri? instagramWebUrl;
    Uri? instagramDeepLinkUrl;
    if (group.instagramUrl != null && group.instagramUrl!.isNotEmpty) {
      instagramWebUrl = Uri.parse(group.instagramUrl!);
      final instagramUserName = instagramWebUrl.pathSegments.last;
      instagramDeepLinkUrl = Uri.parse('$instagramScheme$instagramUserName');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(group.imageUrl!),
              radius: avaterSizeLL,
            ),
            Row(
              children: [
                if (officialUrl != null)
                  IconButton(
                    onPressed: () {
                      openOfficialSite(officialUrl!);
                    },
                    icon: Icon(
                      FontAwesomeIcons.house,
                      color: mainBlue,
                    ),
                  ),
                if (twitterWebUrl != null)
                  IconButton(
                    onPressed: () {
                      openTwitter(twitterDeepLinkUrl!, twitterWebUrl!);
                    },
                    icon: Icon(
                      FontAwesomeIcons.twitter,
                      color: mainBlue,
                    ),
                  ),
                if (instagramWebUrl != null)
                  IconButton(
                    onPressed: () {
                      openInstagram(instagramDeepLinkUrl!, instagramWebUrl!);
                    },
                    icon: Icon(
                      FontAwesomeIcons.instagram,
                      color: mainBlue,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const Gap(spaceS),
        if (group.comment != null)
          Text(
            group.comment!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        const Gap(spaceS),
        if (group.year == null)
          Text(
            '結成年：不明',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        else
          Text(
            '結成年：${group.year}年',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }
}
