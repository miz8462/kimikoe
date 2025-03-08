import 'package:flutter/material.dart';
import 'package:kimikoe_app/config/config.dart';

Container circleColor(Color? color) {
  return Container(
    width: circleSize,
    height: circleSize,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: (color == Colors.white)
          ? Border.all(
              color: Colors.grey,
              width: 0.5,
            )
          : null,
    ),
  );
}
