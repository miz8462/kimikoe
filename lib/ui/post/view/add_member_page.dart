import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/widgets/styled_button.dart';
import 'package:kimikoe_app/ui/widgets/circular_button.dart';
import 'package:kimikoe_app/ui/widgets/expanded_text_form.dart';
import 'package:kimikoe_app/ui/widgets/text_form.dart';

class AddMemberPage extends StatelessWidget {
  const AddMemberPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '*必須項目',
          style: TextStyle(color: textGray, fontSize: fontSS),
        ),
        const TextForm(hintText: '*名前'),
        const Gap(spaceWidthS),
        const TextForm(hintText: '*所属グループ'),
        const Gap(spaceWidthS),
        // 歌詞で表示する個人カラー選択
        Row(
          children: [
            CircularButton(color: Colors.pink.shade200),
            const Text(
              '*カラー選択',
              style: TextStyle(color: textGray, fontSize: fontM),
            ),
          ],
        ),
        // メンバー画像
        const StyledButton(
          'メンバー画像',
          textColor: textGray,
          backgroundColor: backgroundWhite,
          buttonSize: buttonS,
          borderSide:
              BorderSide(color: backgroundLightBlue, width: borderWidth),
        ),
        const Gap(spaceWidthS),
        const TextForm(hintText: '生年月日'),
        const Gap(spaceWidthS),
        const TextForm(hintText: '身長'),
        const Gap(spaceWidthS),
        const TextForm(hintText: '出身地'),
        const Gap(spaceWidthS),
        const TextForm(hintText: 'デビュー年'),
        const Gap(spaceWidthS),
        const ExpandedTextForm(hintText: 'その他、備考'),
        const Gap(spaceWidthS),
        const StyledButton('登録', buttonSize: buttonL),
        const Gap(spaceWidthS),
      ],
    );
  }
}