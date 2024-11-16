import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kimikoe_app/config/config.dart';
import 'package:kimikoe_app/router/router.dart';

const Color mainColor = Color(0xFF38B6FF);
var kColorScheme = ColorScheme.fromSeed(seedColor: mainColor);

// AppBarとBottomNavigationBarの設計
// bodyに子要素として各ページを受け取る

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
        // textTheme: GoogleFonts.mPlus1TextTheme(Theme.of(context).textTheme),
        textTheme: GoogleFonts.kosugiMaruTextTheme(Theme.of(context).textTheme),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: textWhite),
          ),
        ),
      ),
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
    );
  }
}
