import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/widgets/circle_color.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: CircleColor(color),
            ),
            const Gap(8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 16,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
        const Gap(8),
      ],
    );
  }

  
}
