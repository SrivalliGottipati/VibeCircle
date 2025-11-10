import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.base1,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primaryAccent,
      surface: AppColors.base2,
      onSurface: AppColors.text1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.base2,
      hintStyle: const TextStyle(color: AppColors.text3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primaryAccent),
      ),
    ),
  );
}
