import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kimikoe_app/config/config.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton(this.socialName,
      {required this.imagePath, super.key});
  final void Function() socialName;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    const double height = 40;
    const double width = 40;
    const Color textColor = textWhite;

    return IconButton(
      onPressed: socialName,
      icon: SvgPicture.asset(
        height: height,
        width: width,
        imagePath,
        colorFilter: const ColorFilter.mode(textColor, BlendMode.srcIn),
      ),
    );
  }
}
