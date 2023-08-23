import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:photo_gallery/ui/styling/_index.dart';

class AppTheme {
  static ThemeData buildLightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xffEEEEF6),
        centerTitle: false,
        titleTextStyle: TextStyle(color: Color(0xff335778), fontSize: 20.0, fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: AppLightColors.primary),
        elevation: 0.0),
    colorScheme: const ColorScheme.light(
      primary: AppLightColors.primary,
      inversePrimary: Color(0xff19167B),
      secondary: AppLightColors.secondary,
      secondaryContainer: Color(0xffF9F9FE),
      primaryContainer: Colors.white,
      background: Colors.white,
      error: Colors.red,
    ),
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(color: Color(0xff335778), fontWeight: FontWeight.w700),
      contentTextStyle: TextStyle(
        fontSize: 13,
        color: Color(0xff335778),
      ),
    ),
    textTheme: GoogleFonts.manropeTextTheme().copyWith(
      displayLarge: const TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w700),
      displayMedium: const TextStyle(color: AppLightColors.primary, fontSize: 16.0, fontWeight: FontWeight.w500),
      displaySmall: const TextStyle(color: Colors.white, fontSize: 14.0),
      headlineLarge: const TextStyle(color: AppLightColors.secondary, fontSize: 24.0, fontWeight: FontWeight.w700),
      headlineMedium: const TextStyle(color: AppLightColors.primary, fontSize: 12.0, fontWeight: FontWeight.w700),
      headlineSmall: const TextStyle(color: AppLightColors.secondary, fontSize: 12.0, fontWeight: FontWeight.w500),
      titleLarge: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w700),
      titleSmall: const TextStyle(color: Color(0xff7F818D), fontSize: 10.0, fontWeight: FontWeight.w500),
      titleMedium: const TextStyle(
        color: Color(0xff56718A),
        fontSize: 12.0,
      ),
      bodySmall: const TextStyle(color: AppLightColors.primary, fontSize: 12.0, fontWeight: FontWeight.w500),
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      shadowColor: AppLightColors.shadowColor,
    ),
    dividerColor: AppLightColors.dividerColor,
    dividerTheme: const DividerThemeData(color: AppLightColors.dividerColor),
    disabledColor: Colors.grey,
  );
}
