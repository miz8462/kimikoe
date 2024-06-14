import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/group-page'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 画像をClipRRectで囲って角を丸くする
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const Image(
                image: AssetImage('assets/images/poison_palette.jpg'),
              ),
            ),
            const Text(
              'Poison Palette',
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
