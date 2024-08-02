import 'package:flutter/material.dart';

class TitleLogo extends StatelessWidget {
  const TitleLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Image(
              image: AssetImage('assets/images/Kimikoe_Logo.png'),
            ),
          ],
        ),
      ),
    );
  }
}
