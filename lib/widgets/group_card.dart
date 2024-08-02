import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.name,
    required this.imageUrl,
  });
  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('group-page'),
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
                imageUrl,
                height: 130,
                width: 130,
              ),
            ),
            Text(
              name,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
