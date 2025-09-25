import 'package:flutter/material.dart';

class FkColors {
  static const Color primary = Color(0xFFB95E82);
  static const Color secondary = Color(0xFFF39F9F);
  static const Color accent = Color(0xFFb0c7ff);

  static const MaterialColor materialColor = MaterialColor(0xFFB95E82, {
    50:  Color(0xFFF9E9EF),
    100: Color(0xFFF2C8D7),
    200: Color(0xFFEAA5BD),
    300: Color(0xFFE182A3),
    400: Color(0xFFDA678F),
    500: Color(0xFFB95E82), // primary
    600: Color(0xFFA95579),
    700: Color(0xFF954B6E),
    800: Color(0xFF824263),
    900: Color(0xFF633251),
  });

  // Text colors
  static const Color textPrimary = Color(0xFF2C3E50); // dark navy/blue-gray
  static const Color textSecondary = Color(0xFF6B7B8C); // muted gray-blue
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color(0xFFF6F7F9); // very light gray-blue
  static const Color dark = Color(0xFF1C1E22); // near black
  static const Color primaryBackground = Color(0xFFEAF0F5); // soft tint of primary

  // Background Container colors
  static const Color lightContainer = Color(0xFFF2F4F6);
  static Color darkContainer = FkColors.white.withValues(alpha: 0.08);

  // Button colors
  static const Color buttonPrimary = Color(0xFFB95E82); // main primary
  static const Color buttonSecondary = Color(0xFF6B7B8C);
  static const Color buttonDisabled = Color(0xFFBFC5CC); // greyed-out blue tone

  // Border colors
  static const Color borderPrimary = Color(0xFFD0D5DA);
  static const Color borderSecondary = Color(0xFFE4E7EB);

  // Status colors (kept standard)
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF8A8F94);
  static const Color grey = Color(0xFFDDE1E5);
  static const Color softGrey = Color(0xFFF3F5F7);
  static const Color lightGrey = Color(0xFFF9FAFB);
  static const Color white = Color(0xFFFFFFFF);
}
