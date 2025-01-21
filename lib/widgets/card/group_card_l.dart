import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class GroupCardL extends StatelessWidget {
  const GroupCardL({
    required this.group,
    this.imageProvider,
    super.key,
  });
  final IdolGroup group;
  final ImageProvider? imageProvider;

  @override
  Widget build(BuildContext context) {
    final image = imageProvider ?? NetworkImage(group.imageUrl);
    return GestureDetector(
      onTap: () => context.push(
        '${RoutingPath.groupList}/${RoutingPath.songList}',
        extra: group,
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: backgroundWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3), // 影の色
              offset: const Offset(4, 4), // 右下方向に影をオフセット
              blurRadius: 5, // 影のぼかしの大きさ
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 画像をClipRRectで囲って角を丸くする
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: image,
                  height: 130,
                  width: 130,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              group.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
