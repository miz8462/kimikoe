import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/main.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/services/supabase_service.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/utils/open_links.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';

class IdolDetailScreen extends StatefulWidget {
  const IdolDetailScreen({
    required this.idol,
    super.key,
  });

  final Idol idol;

  @override
  State<IdolDetailScreen> createState() => _IdolDetailScreenState();
}

class _IdolDetailScreenState extends State<IdolDetailScreen> {
  Uri? twitterWebUrl;
  Uri? twitterDeepLinkUrl;
  Uri? instagramWebUrl;
  Uri? instagramDeepLinkUrl;
  Uri? otherUrl;

  Future<void> getTwitterUrls(String? url) async {
    final urls = await fetchWebUrlAndDeepLinkUrl(url, scheme: twitterScheme);
    twitterWebUrl = urls.webUrl;
    twitterDeepLinkUrl = urls.deepLinkUrl;

    setState(() {});
  }

  Future<void> getInstagramUrls(String? url) async {
    final urls = await fetchWebUrlAndDeepLinkUrl(url, scheme: instagramScheme);
    instagramWebUrl = urls.webUrl;
    instagramDeepLinkUrl = urls.deepLinkUrl;

    setState(() {});
  }

  Future<void> getOtherUrl(String? url) async {
    otherUrl = await convertUrlStringToUri(url);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final idol = widget.idol;
    getTwitterUrls(idol.twitterUrl);
    getInstagramUrls(idol.instagramUrl);
    getOtherUrl(idol.otherUrl);
  }

  void _deleteIdol() {
    showDialog<Widget>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () async {
            await deleteDataFromTable(
              table: TableName.idols,
              targetColumn: ColumnName.id,
              targetValue: widget.idol.id.toString(),
              context: context,
              supabase: supabase,
            );
          },
          successMessage: '${widget.idol.name}のデータが削除されました',
          errorMessage: '${widget.idol.name}のデータの削除に失敗しました',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final idol = widget.idol;
    const isEditing = true;
    final data = {
      'idol': idol,
      'isEditing': isEditing,
    };

    late String formattedBirthDay;
    if (idol.birthDay != null &&
        idol.birthDay!.isNotEmpty &&
        idol.birthYear != null &&
        idol.birthYear != 0) {
      final birthday = '${idol.birthYear}-${idol.birthDay}';
      formattedBirthDay = formatStringDateToJapaneseWithYear(birthday);
    } else if (idol.birthDay != null && idol.birthDay!.isNotEmpty) {
      final birthday = '0000-${idol.birthDay}';
      if (idol.birthDay != null) {
        formattedBirthDay = formatStringDateToJapaneseOnlyMonthAndDay(birthday);
      }
    } else if (idol.birthYear != null && idol.birthYear != 0) {
      formattedBirthDay = '${idol.birthYear}年';
    } else {
      formattedBirthDay = '不明';
    }

    late String hometown;
    if (idol.hometown == null || idol.hometown!.isEmpty) {
      hometown = '不明';
    } else {
      hometown = idol.hometown!;
    }

    return Scaffold(
      appBar: TopBar(
        pageTitle: idol.name,
        isEditing: isEditing,
        delete: _deleteIdol,
        editRoute: RoutingPath.addIdol,
        data: data,
      ),
      body: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(spaceS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.idol.imageUrl),
                  radius: avaterSizeLL,
                ),
                Row(
                  children: [
                    if (twitterWebUrl != null)
                      IconButton(
                        onPressed: () {
                          openAppOrWeb(twitterDeepLinkUrl!, twitterWebUrl!);
                        },
                        icon: Icon(
                          FontAwesomeIcons.twitter,
                          color: mainColor,
                        ),
                      ),
                    if (instagramWebUrl != null)
                      IconButton(
                        onPressed: () {
                          openAppOrWeb(instagramDeepLinkUrl!, instagramWebUrl!);
                        },
                        icon: Icon(
                          FontAwesomeIcons.instagram,
                          color: mainColor,
                        ),
                      ),
                    if (otherUrl != null)
                      IconButton(
                        onPressed: () {
                          openWebSite(otherUrl!);
                        },
                        icon: Icon(
                          FontAwesomeIcons.link,
                          color: mainColor,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const Gap(spaceS),
            Row(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius12,
                    color: idol.color,
                  ),
                ),
                const Gap(spaceS),
                if (idol.group != null)
                  Text(
                    idol.group!.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
              ],
            ),
            const Gap(spaceS),
            if (idol.comment != null)
              Text(
                idol.comment!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            Divider(
              color: mainColor.withOpacity(0.3),
              thickness: 2,
            ),
            Text(
              '誕生日：$formattedBirthDay',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Gap(spaceS),
            if (idol.height == null || idol.height == 0)
              Text(
                '身長：不明',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              Text(
                '身長：${idol.height}cm',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const Gap(spaceS),
            Text(
              '出身地：$hometown',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Gap(spaceS),
            if (idol.debutYear == null || idol.debutYear == 0)
              Text(
                'デビュー：不明',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              Text(
                'デビュー：${idol.debutYear}年',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            // Gap(spaceS),
          ],
        ),
      ),
    );
  }
}
