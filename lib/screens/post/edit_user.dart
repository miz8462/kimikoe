import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/buttons/styled_button.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  var _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: 'ユーザー編集'),
      body: Padding(
        padding: screenPadding,
        child: Column(
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
                  hintText: '*名前',
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
                    borderRadius: borderRadius8,
                  ),
                  side: const BorderSide(
                      color: backgroundLightBlue, width: borderWidth),
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
            Container(
              color: backgroundLightBlue,
              child: TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'メール',
                  hintStyle: TextStyle(color: textGray),
                  contentPadding: EdgeInsets.only(left: spaceWidthS),
                ),
                controller: TextEditingController(),
              ),
            ),
            const Gap(spaceWidthS),
            // 備考欄
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
            StyledButton(
              '登録',
              onPressed: () => context.push(RoutingPath.userDetails),
              isSending: _isSending,
              buttonSize: buttonL,
            ),
            const Gap(spaceWidthS),
          ],
        ),
      ),
    );
  }
}
