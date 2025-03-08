import 'package:flutter/material.dart';
import 'package:kimikoe_app/kimikoe_app.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    required this.onPressed,
    super.key,
    this.color = mainColor,
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
        side: (color == Colors.white)
            ? BorderSide(
                color: Colors.grey,
                width: 0.5,
              )
            : BorderSide.none,
      ),
      child: const Text(''),
    );
  }
}
