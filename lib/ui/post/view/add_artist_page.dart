import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/widgets/button.dart';
import 'package:kimikoe_app/ui/widgets/text_form.dart';

class AddArtistPage extends StatelessWidget {
  const AddArtistPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '*必須項目',
          style: TextStyle(color: textGray),
        ),
        // アーティスト名入力
        // todo: クラスウィジェット作る
        TextForm(hintText: '*アーティスト名'),
        const Gap(spaceWidthS),
        // ユーザー画像登録ボタン
        const Button(
          'アーティスト画像',
          textColor: textGray,
          backgroundColor: backgroundWhite,
          buttonSize: buttonS,
          borderSide:
              BorderSide(color: backgroundLightBlue, width: borderWidth),
        ),
        const Gap(spaceWidthS),
        // 備考欄
        // todo: '備考'をもっと上に表示したい
        Expanded(
          child: Container(
            color: backgroundLightBlue,
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '備考',
                hintStyle: TextStyle(
                  color: textGray,
                  height: 0,
                ),
                contentPadding: EdgeInsets.only(left: spaceWidthS),
              ),
              controller: TextEditingController(),
              maxLines: null,
            ),
          ),
        ),
        const Gap(spaceWidthS),
        // 登録ボタン
        const Button(
          '登録',
          buttonSize: buttonL,
        ),
        const Gap(spaceWidthS),
      ],
    );
  }
}
