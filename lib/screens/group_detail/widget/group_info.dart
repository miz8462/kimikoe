import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/utils/open_links.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo({super.key, required this.group});
  final IdolGroup group;

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Uri? officialUrl;
  Uri? twitterWebUrl;
  Uri? twitterDeepLinkUrl;
  Uri? instagramWebUrl;
  Uri? instagramDeepLinkUrl;

  Future<void> getOfficialUrl(String? url) async {
    officialUrl = await convertUrlStringToUri(url);
    setState(() {});
  }

  Future<void> getTwitterUrls(String? url) async {
    final urls = await fetchWebUrlAndDeepLinkUrl(url, twitterScheme);
    twitterWebUrl = urls.webUrl;
    twitterDeepLinkUrl = urls.deepLinkUrl;

    setState(() {});
  }

  Future<void> getInstagramUrls(String? url) async {
    final urls = await fetchWebUrlAndDeepLinkUrl(url, instagramScheme);
    instagramWebUrl = urls.webUrl;
    instagramDeepLinkUrl = urls.deepLinkUrl;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final group = widget.group;
    getOfficialUrl(group.officialUrl);
    getTwitterUrls(group.twitterUrl);
    getInstagramUrls(group.instagramUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.group.imageUrl!),
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
        if (widget.group.comment != null)
          Text(
            widget.group.comment!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        const Gap(spaceS),
        if (widget.group.year == null)
          Text(
            '結成年：不明',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        else
          Text(
            '結成年：${widget.group.year}年',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }
}
