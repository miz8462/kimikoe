import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
    this.color = mainBlue,
    required this.onPressed,
  });

  final Color color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        shape: const CircleBorder(),
        side: BorderSide.none,
      ),
      child: const Text(''),
    );
  }
}
