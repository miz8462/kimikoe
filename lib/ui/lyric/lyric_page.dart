import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/widgets/border_button.dart';
import 'package:kimikoe_app/ui/widgets/styled_text.dart';

class LyricPage extends StatelessWidget {
  const LyricPage({super.key});

  @override
  Widget build(BuildContext context) {
    const circleSize = 20.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(spaceWidthM),
        // 曲情報
        Container(
          height: 140,
          padding: EdgeInsets.all(spaceWidthSS),
          decoration: BoxDecoration(color: backgroundLightBlue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // 曲名
                  StyledText(
                    'Sound Paradise',
                    fontSize: fontL,
                  ),
                  // アーティスト
                  StyledText(
                    'Poison Palette',
                    fontSize: fontS,
                  ),
                  Gap(spaceWidthL),
                  // 作詞家
                  StyledText('作詞：TEI'),
                  // 作曲家
                  StyledText('作曲：IgA'),
                  // 発売日
                  StyledText('発売日：2023/09/29'),
                ],
              ),
              Image.asset(
                'assets/images/soundparadise.webp',
                height: 130,
              ),
            ],
          ),
        ),
        Gap(spaceWidthM),
        // アーティスト一覧、追加ボタン
        Row(
          children: [
            // 色丸
            Container(
              width: circleSize,
              height: circleSize,
              decoration: const BoxDecoration(
                color: Colors.pink, // 好きな色を指定
                shape: BoxShape.circle, // 円形を指定
              ),
            ),
            Gap(spaceWidthSS),

            // 名前
            const Text('Momo'), Gap(spaceWidthM),

            // 色丸
            Container(
              width: circleSize,
              height: circleSize,
              decoration: const BoxDecoration(
                color: Colors.red, // 好きな色を指定
                shape: BoxShape.circle, // 円形を指定
              ),
            ),
            Gap(spaceWidthSS),

            // 名前
            const Text('Sora'), Gap(spaceWidthM),

            Container(
              width: circleSize,
              height: circleSize,
              decoration: const BoxDecoration(
                color: Colors.purple, // 好きな色を指定
                shape: BoxShape.circle, // 円形を指定
              ),
            ),
            Gap(spaceWidthSS),
            // 名前
            const Text('Shuka'),
            Gap(spaceWidthM),
            // 色丸
            Container(
              width: circleSize,
              height: circleSize,
              decoration: const BoxDecoration(
                color: Colors.yellow, // 好きな色を指定
                shape: BoxShape.circle, // 円形を指定
              ),
            ),
            Gap(spaceWidthSS),
            // 名前
            const Text('Ami'),
          ],
        ),
        Gap(spaceWidthM),
        BorderButton(
          'メンバー追加',
          width: 200,
        ),
      ],
    );
  }
}
