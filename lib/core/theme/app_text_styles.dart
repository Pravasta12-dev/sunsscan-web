import 'package:flutter/material.dart';
import 'package:sun_scan/core/injection/injection.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = Injection.fontFamily;

  static TextStyle get bold =>
      const TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold);

  static TextStyle get caption => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    color: AppColors.whiteColor,
  );

  static TextStyle get body => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: AppColors.whiteColor,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    color: AppColors.whiteColor,
  );

  static TextStyle get subtitle => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    color: AppColors.whiteColor,
  );

  static TextStyle get title => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    color: AppColors.whiteColor,
  );

  static TextStyle get heading => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    color: AppColors.whiteColor,
  );
}
