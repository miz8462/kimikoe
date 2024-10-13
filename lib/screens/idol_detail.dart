import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/enums/table_and_column_name.dart';
import 'package:kimikoe_app/models/idol.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/utils/crud_data.dart';
import 'package:kimikoe_app/utils/date_formatter.dart';
import 'package:kimikoe_app/widgets/delete_alert_dialog.dart';

class IdolDetailScreen extends StatefulWidget {
  const IdolDetailScreen({
    super.key,
    required this.idol,
  });

  final Idol idol;

  @override
  State<IdolDetailScreen> createState() => _IdolDetailScreenState();
}

class _IdolDetailScreenState extends State<IdolDetailScreen> {
  void _deleteIdol() {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAlertDialog(
          onDelete: () {
            deleteDataFromTable(
              table: TableName.idol.name,
              column: ColumnName.id.name,
              value: (widget.idol.id).toString(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final idol = widget.idol;
    final isEditing = true;
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
        title: idol.name,
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
            CircleAvatar(
              backgroundImage: NetworkImage(idol.imageUrl!),
              radius: avaterSizeLL,
            ),
            // todo: Twitterやインスタのリンク
            const Gap(spaceS),
            Row(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                      borderRadius: borderRadius12, color: idol.color),
                ),
                const Gap(spaceS),
                if (idol.group != null)
                  Text(
                    idol.group!.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  )
              ],
            ),
            const Gap(spaceS),
            if (idol.comment != null)
              Text(
                idol.comment!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            Divider(
              color: mainBlue.withOpacity(0.3),
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
