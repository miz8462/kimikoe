import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/models/idol_group.dart';
import 'package:kimikoe_app/router/routing_path.dart';

class GroupCardL extends StatelessWidget {
  const GroupCardL({
    super.key,
    required this.group,
  });
  final IdolGroup group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '${RoutingPath.groupList}/${RoutingPath.songList}',
        extra: group,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // 影の色
              offset: const Offset(4, 4), // 右下方向に影をオフセット
              blurRadius: 5, // 影のぼかしの大きさ
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 画像をClipRRectで囲って角を丸くする
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                group.imageUrl!,
                height: 130,
                width: 130,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              group.name,
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
