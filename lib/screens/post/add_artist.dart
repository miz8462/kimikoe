import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/widgets/expanded_text_form.dart';
import 'package:kimikoe_app/widgets/styled_button.dart';
import 'package:kimikoe_app/widgets/text_form.dart';

class AddArtistScreen extends StatelessWidget {
  const AddArtistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '*必須項目',
          style: TextStyle(color: textGray),
        ),
        // アーティスト名入力
        // todo: クラスウィジェット作る
        TextForm(hintText: '*アーティスト名'),
        Gap(spaceWidthS),
        // ユーザー画像登録ボタン
        StyledButton(
          'アーティスト画像',
          onPressed: () {},
          textColor: textGray,
          backgroundColor: backgroundWhite,
          buttonSize: buttonS,
          borderSide:
              BorderSide(color: backgroundLightBlue, width: borderWidth),
        ),
        Gap(spaceWidthS),
        // 備考欄
        // ExpandedTextForm(label: '備考'),
        Gap(spaceWidthS),
        // 登録ボタン
        StyledButton(
          '登録',
          onPressed: () {
            context.go('/home');
          },
          buttonSize: buttonL,
        ),
        Gap(spaceWidthS),
      ],
    );
  }
}
