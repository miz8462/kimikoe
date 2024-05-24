import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/widgets/styled_button.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});
  @override
  Widget build(context) {
    const String userName = 'おぱんちゅうさぎ';
    const String userInfo =
        'おぱんちゅうさぎはピンク色のうさぎで、地球に住むみんなのおともだち。いつもみんなを助けたくって、励ましたくって、奔走してくれています。';
    const String avaterImage = 'assets/images/opanchu_ashiyu.jpg';
    const String editButtonText = '編集する';
    const double buttonWidth = 180;

    return const Column(
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
            StyledButton(
              editButtonText,
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
    );
  }
}
