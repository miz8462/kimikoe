import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kimikoe_app/config/config.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton(
    this.socialLogin, {
    required this.imagePath,
    super.key,
  });
  final void Function() socialLogin;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    const height = 40.0;
    const width = 40.0;
    const textColor = textWhite;

    return IconButton(
      onPressed: socialLogin,
      icon: SvgPicture.asset(
        imagePath,
        height: height,
        width: width,
        colorFilter: const ColorFilter.mode(textColor, BlendMode.srcIn),
      ),
    );
  }
}
