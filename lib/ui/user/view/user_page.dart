import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/ui/widgets/button.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});
  @override
  Widget build(context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(spaceWidthS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/opanchu_ashiyu.jpg'),
              radius: 20,
            ),
            Button(
              '編集する',
              textColor: textGray,
              backgroundColor: backgroundWhite,
              buttonSize: buttonM,
              borderSide:
                  BorderSide(color: backgroundLightBlue, width: borderWidth),
              width: 180,
            ),
          ],
        ),
        Gap(spaceWidthS),
        Text(
          'おぱんちゅうさぎ',
          style: TextStyle(
            fontSize: fontLL,
          ),
        ),
        Gap(spaceWidthS),
        Text(
            'おぱんちゅうさぎはピンク色のうさぎで、地球に住むみんなのおともだち。いつもみんなを助けたくって、励ましたくって、奔走してくれています。'),
      ],
    );
  }
}
