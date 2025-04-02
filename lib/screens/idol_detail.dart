import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/kimikoe_app.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/models/table_and_column_name.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/providers/group_members_provider.dart';
import 'package:kimikoe_app/providers/logger_provider.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/services/supabase_services/supabase_services.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/utils/open_links.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';
import 'package:kimikoe_app/widgets/text/one_line_text.dart';

class IdolDetailScreen extends ConsumerStatefulWidget {
  const IdolDetailScreen({
    required this.idol,
    super.key,
  });

  final Idol idol;

  @override
  ConsumerState<IdolDetailScreen> createState() => _IdolDetailScreenState();
}

class _IdolDetailScreenState extends ConsumerState<IdolDetailScreen> {
  Uri? twitterWebUrl;
  Uri? twitterDeepLinkUrl;
  Uri? instagramWebUrl;
  Uri? instagramDeepLinkUrl;
  Uri? otherUrl;
  late Future<bool> isImageAvailable;

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

  Future<bool> isImageInStorage(String url) async {
    final isExist = await isUrlExists(url);

    // デバッグ用のログを追加
    logger.d('Checking image availability for URL: $url');
    logger.d('Can launch URL: $isExist');

    return isExist;
  }

  @override
  void initState() {
    super.initState();
    final idol = widget.idol;
    getTwitterUrls(idol.twitterUrl);
    getInstagramUrls(idol.instagramUrl);
    getOtherUrl(idol.otherUrl);
    isImageAvailable = isImageInStorage(idol.imageUrl);
  }

  void _deleteIdol() {
    showDialog<Widget>(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          key: Key(WidgetKeys.deleteIdol),
          onDelete: () async {
            await SupabaseServices.delete.deleteDataByName(
              table: TableName.idols,
              name: widget.idol.name,
            );

            final groupId = widget.idol.group!.id;
            await ref
                .read(groupMembersProvider(groupId!).notifier)
                .fetchIdols();
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
                FutureBuilder<bool>(
                  future: isImageAvailable,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError ||
                        !snapshot.hasData ||
                        !snapshot.data!) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(noImage),
                        radius: avaterSizeLL,
                      );
                    } else {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(idol.imageUrl),
                        radius: avaterSizeLL,
                      );
                    }
                  },
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
                  Expanded(
                    child: OneLineText(
                      idol.group!.name,
                      fontSize: fontM,
                    ),
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
              color: mainColor.withValues(alpha: 0.3),
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
