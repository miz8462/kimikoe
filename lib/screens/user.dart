import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/router/routing_path.dart';
import 'package:kimikoe_app/screens/appbar/top_bar.dart';
import 'package:kimikoe_app/widgets/styled_button.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
    var _isSending = false;

  @override
  Widget build(context) {
    const String userName = 'おぱんちゅうさぎ';
    const String userInfo =
        'おぱんちゅうさぎはピンク色のうさぎで、地球に住むみんなのおともだち。いつもみんなを助けたくって、励ましたくって、奔走してくれています。';
    const String avaterImage = 'assets/images/opanchu_ashiyu.jpg';
    const String editButtonText = '編集する';
    const double buttonWidth = 180;

    return Scaffold(
      appBar: TopBar(
        title: 'ユーザー情報',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(spaceWidthS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(avaterImage),
                radius: 20,
              ),
              // 編集
              // todo: 他のページに遷移したら編集を終了する
              StyledButton(
                editButtonText,
                onPressed: () {
                  context.push(
                      '${RoutingPath.userDetails}/${RoutingPath.editUser}');
                },                  isSending: _isSending,

                textColor: textGray,
                backgroundColor: backgroundWhite,
                buttonSize: buttonM,
                borderSide:
                    BorderSide(color: backgroundLightBlue, width: borderWidth),
                width: buttonWidth,
              ),
            ],
          ),
          Gap(spaceWidthS),
          Text(
            userName,
            style: TextStyle(
              fontSize: fontLL,
            ),
          ),
          Gap(spaceWidthS),
          Text(userInfo),
        ],
      ),
    );
  }
}
