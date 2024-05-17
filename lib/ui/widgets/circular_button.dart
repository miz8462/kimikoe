import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    this.color = mainBlue,
    super.key,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        shape: const CircleBorder(),
        side: BorderSide.none,
      ),
      child: const Text(''),
    );
  }
}
