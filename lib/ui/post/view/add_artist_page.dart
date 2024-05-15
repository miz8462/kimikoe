import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';

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
        Container(
          color: backgroundLightBlue,
          child: TextFormField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '*アーティスト名(作詞家、作曲家)',
              hintStyle: TextStyle(color: textGray),
              contentPadding: EdgeInsets.only(left: spaceWidthS),
            ),
            controller: TextEditingController(),
          ),
        ),
        const Gap(spaceWidthS),
        // ユーザー画像登録ボタン
        SizedBox(
          height: 40,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: backgroundWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              side: const BorderSide(color: backgroundLightBlue, width: borderWidth),
              fixedSize: const Size.fromWidth(double.maxFinite),
            ),
            child: const Text(
              'ユーザー画像',
              style: TextStyle(
                color: textGray,
              ),
            ),
          ),
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
        SizedBox(
          height: 40,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: mainBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              side: BorderSide.none,
              fixedSize: const Size.fromWidth(double.maxFinite),
            ),
            child: const Text(
              '登録',
              style: TextStyle(color: textWhite),
            ),
          ),
        ),
        const Gap(spaceWidthS),
      ],
    );
  }
}
