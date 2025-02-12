import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/models/widget_keys.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class GroupCardM extends StatelessWidget {
  const GroupCardM({
    required this.group,
    this.imageProvider,
    super.key,
  });
  final IdolGroup group;
  final ImageProvider? imageProvider;

  @override
  Widget build(BuildContext context) {
    final groupName = group.name;
    final groupImage = group.imageUrl;
    final groupInfo = group.comment;

    final image = imageProvider ?? NetworkImage(groupImage);

    return GestureDetector(
      key: Key(WidgetKeys.groupCardM),
      onTap: () {
        context.pushNamed(RoutingPath.groupDetail, extra: group);
      },
      child: Card(
        elevation: 6,
        color: backgroundLightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius4,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: CircleAvatar(
                backgroundImage: image,
                radius: avaterSizeL,
                // ignore: unnecessary_null_comparison
                child: groupImage == null ? const Icon(Icons.person) : null,
              ),
            ),
            const Gap(spaceL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupName,
                    style: const TextStyle(
                      fontSize: fontLL,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                  Text(
                    groupInfo ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: fontSS,
                      color: textDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
