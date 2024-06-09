import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class DivideLine extends StatelessWidget {
  const DivideLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: textWhite,
            thickness: 2,
          ),
        ),
        Text(
          "    OR    ",
          style: TextStyle(
            color: textWhite,
            fontSize: fontS,
          ),
        ),
        Expanded(
          child: Divider(
            color: textWhite,
            thickness: 2,
          ),
        ),
      ],
    );
  }
}
