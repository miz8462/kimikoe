import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/widgets/circular_button.dart';
import 'package:kimikoe_app/widgets/styled_button.dart';
import 'package:kimikoe_app/widgets/text_form.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});
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
        StyledButton(
          'メンバー画像',
          onPressed: () {},
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
        // const ExpandedTextForm(label: 'その他、備考'),
        const Gap(spaceWidthS),
        StyledButton(
          '登録',
          onPressed: () {
            context.go('/group_list');
          },
          buttonSize: buttonL,
        ),
        const Gap(spaceWidthS),
      ],
    );
  }
}
