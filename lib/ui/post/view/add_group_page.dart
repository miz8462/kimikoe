import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/widgets/styled_button.dart';
import 'package:kimikoe_app/ui/widgets/expanded_text_form.dart';

class AddGroupPage extends StatelessWidget {
  const AddGroupPage({super.key});
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
        Container(
          color: backgroundLightBlue,
          child: TextFormField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '*グループ名',
              hintStyle: TextStyle(color: textGray),
              contentPadding: EdgeInsets.only(left: spaceWidthS),
            ),
            controller: TextEditingController(),
          ),
        ),
        const Gap(spaceWidthS),
        // ユーザー画像登録ボタン
        const StyledButton(
          'グループ画像',
          textColor: textGray,
          backgroundColor: backgroundWhite,
          buttonSize: buttonS,
          borderSide:
              BorderSide(color: backgroundLightBlue, width: borderWidth),
        ),
        const Gap(spaceWidthS),
        Container(
          color: backgroundLightBlue,
          child: TextFormField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '結成年',
              hintStyle: TextStyle(color: textGray),
              contentPadding: EdgeInsets.only(left: spaceWidthS),
            ),
            controller: TextEditingController(),
          ),
        ),
        const Gap(spaceWidthS),
        // 備考欄
        // todo: '備考'をもっと上に表示したい
        ExpandedTextForm(hintText: '備考'),
        const Gap(spaceWidthS),
        // 登録ボタン
        const StyledButton(
          '登録',
          buttonSize: buttonL,
        ),
        const Gap(spaceWidthS),
      ],
    );
  }
}
