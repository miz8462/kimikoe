import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';

class CustomTextForLyrics extends StatelessWidget {
  const CustomTextForLyrics(
    this.text, {
    this.color,
    super.key,
  });
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Gap(8),
            Text(
              text,
              style: TextStyle(color: textDark),
            ),
          ],
        ),
        Gap(8),
      ],
    );
  }
}
