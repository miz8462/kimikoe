import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/router/router.dart';

const Color mainColor = Color(0xFF38B6FF);
ColorScheme kColorScheme = ColorScheme.fromSeed(seedColor: mainColor);

class KimikoeApp extends StatelessWidget {
  const KimikoeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'キミコエ',
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        primaryColor: mainColor,
        textTheme: GoogleFonts.kosugiMaruTextTheme(Theme.of(context).textTheme),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: textWhite),
          ),
        ),
      ),
      // TODO: ダークモード
    );
  }
}
