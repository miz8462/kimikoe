import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/screens/widgets/buttons/border_button.dart';
import 'package:kimikoe_app/screens/widgets/highlighted_text.dart';
import 'package:kimikoe_app/screens/widgets/styled_text.dart';

// HylightedTextクラスを作成し行単位でハイライトできるようにする
// 文字が見やすい用に色を調節

class LyricScreen extends StatefulWidget {
  const LyricScreen({super.key});

  @override
  State<LyricScreen> createState() => _LyricScreenState();
}

class _LyricScreenState extends State<LyricScreen> {
  var _isSending = false;

  @override
  Widget build(BuildContext context) {
    const circleSize = 20.0;
    return Scaffold(
      appBar: TopBar(
        title: '歌詞',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(spaceM),
              // 曲情報
              Container(
                height: 140,
                padding: EdgeInsets.all(spaceSS),
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
                        Gap(spaceL),
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
              Gap(spaceM),
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
                  Gap(spaceSS),

                  // 名前
                  const Text('Momo'), Gap(spaceM),

                  // 色丸
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: const BoxDecoration(
                      color: Colors.red, // 好きな色を指定
                      shape: BoxShape.circle, // 円形を指定
                    ),
                  ),
                  Gap(spaceSS),

                  // 名前
                  const Text('Sora'), Gap(spaceM),

                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: const BoxDecoration(
                      color: Colors.purple, // 好きな色を指定
                      shape: BoxShape.circle, // 円形を指定
                    ),
                  ),
                  Gap(spaceSS),
                  // 名前
                  const Text('Shuka'),
                  Gap(spaceM),
                  // 色丸
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: const BoxDecoration(
                      color: Colors.yellow, // 好きな色を指定
                      shape: BoxShape.circle, // 円形を指定
                    ),
                  ),
                  Gap(spaceSS),
                  // 名前
                  const Text('Ami'),
                ],
              ),
              Gap(spaceM),
              BorderButton(
                'メンバー追加',
                onPressed: () {},
                isSending: _isSending,
                width: 200,
              ),
              Gap(spaceL),
              // 歌詞
              Column(
                children: [
                  HighlightedText(
                    'miuちゃん、大好き',
                    highlightColor: Color.fromARGB(78, 79, 195, 241),
                  ),
                ],
              ),
              Gap(spaceM),
            ],
          ),
        ),
      ),
    );
  }
}
