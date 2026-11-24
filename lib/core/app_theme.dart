import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Culori comune folosite în toată aplicația.
class AppColors {
  AppColors._();

  static const teal = Color(0xFF2AB0BE);
  static const primary = Color(0xFF1A8FA8);
  static const mint = Color(0xFF7CC4B4);
  static const dark = Color(0xFF1D1D29);
  static const grey = Color(0xFF8E94A3);
  static const hint = Color(0xFFAAB0C0);
  static const fieldBg = Color(0xFFF4F5FA);
  static const tileBg = Color(0xFFF9F9F9);
  static const chipBg = Color(0xFFF0F0F0);
  static const iconBg = Color(0xFFD5ECEC);
  static const red = Color(0xFFF03E3E);
}

TextStyle outfit(double size, FontWeight weight, Color color) =>
    GoogleFonts.outfit(fontSize: size, fontWeight: weight, color: color);

TextStyle openSans(double size, FontWeight weight, Color color, {double? h}) =>
    GoogleFonts.openSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: h,
    );

ThemeData buildAppTheme() => ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  splashFactory: NoSplash.splashFactory,
);
