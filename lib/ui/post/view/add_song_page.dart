import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/widgets/expanded_text_form.dart';
import 'package:kimikoe_app/ui/widgets/styled_button.dart';
import 'package:kimikoe_app/ui/widgets/text_form.dart';

class AddSongPage extends StatelessWidget {
  const AddSongPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('*必須項目', style: TextStyle(color: textGray, fontSize: fontSS)),
        // タイトル名入力
        // todo: クラスウィジェット作る
        TextForm(hintText: '*タイトル'),
        Gap(spaceWidthS),
        // グループ名入力
        TextForm(hintText: '*グループ名'),
        Gap(spaceWidthS),
        // ユーザー画像登録ボタン
        StyledButton(
          'イメージ画像',
          onPressed: () {},
          textColor: textGray,
          backgroundColor: backgroundWhite,
          buttonSize: buttonS,
          borderSide:
              BorderSide(color: backgroundLightBlue, width: borderWidth),
        ),
        Gap(spaceWidthS),
        // 作詞家入力
        TextForm(hintText: '作詞家'),
        Gap(spaceWidthS),
        // 作曲家入力
        TextForm(hintText: '作曲家'),
        Gap(spaceWidthS),
        // 発売日入力
        TextForm(hintText: '発売日'),
        Gap(spaceWidthS),
        // 備考欄
        // todo: '備考'をもっと上に表示したい
        ExpandedTextForm(hintText: '*歌詞'),
        Gap(spaceWidthS),
        // 登録ボタン
        StyledButton(
          '登録',
          onPressed: () {
            context.go('/');
          },
          buttonSize: buttonL,
        ),
        Gap(spaceWidthS),
      ],
    );
  }
}
