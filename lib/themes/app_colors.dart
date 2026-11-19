import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Default Theme Colors
  static const Color blue = Color(0xFF2563EB);
  static const Color purple = Color(0xFF7C3AED);
  static const Color green = Color(0xFF059669);
  static const Color red = Color(0xFFE11D48);
  static const Color orange = Color(0xFFEA580C);

  // Background Colors
  static const Color lightBackground = Color(0xFFF5F6FA);
  static const Color darkBackground = Color(0xFF101116);

  // Surface Colors
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF1C1D25);

  // Theme List
  static const List<Color> themeColors = [blue, purple, green, red, orange];

  static const List<String> themeNames = [
    'Blue',
    'Purple',
    'Green',
    'Red',
    'Orange',
  ];
}
