import 'package:flutter/material.dart';
import 'app_colors.dart';

class Txt {
  static const _fontFamily = 'Space Grotesk'; // falls back to default if not provided

  static TextStyle h1 = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle h2 = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.1,
  );

  static TextStyle body = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static TextStyle button = const TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.white,
  );
}
