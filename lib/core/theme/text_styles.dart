import 'package:flutter/material.dart';
import 'app_colors.dart';

class Txt {
  static const _fontFamily = 'Space Grotesk';

  static TextStyle h1 = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static TextStyle h2 = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text1,
    letterSpacing: 1.1,
  );

  static TextStyle body = const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    color: AppColors.text3,
  );

  static TextStyle button = const TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.text1, // stays white & consistent
  );
}
