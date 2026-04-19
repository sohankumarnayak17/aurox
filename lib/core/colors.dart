import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color scaffoldBg   = Color(0xFF0D0D0D);
  static const Color surfaceDark  = Color(0xFF161616);
  static const Color surfaceMid   = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2A2A2A);

  static const Color cardWhite    = Color(0xFFF5F5F5);
  static const Color cardWhiteSub = Color(0xFFE8E8E8);

  static const Color accent     = Color(0xFFFFFFFF);
  static const Color accentSoft = Color(0xFFD4D4D4);

  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textMuted     = Color(0xFF5C5C5C);
  static const Color textOnCard    = Color(0xFF0D0D0D);
  static const Color textOnCardSub = Color(0xFF4A4A4A);

  static const Color expense = Color(0xFFFF4D4D);
  static const Color income  = Color(0xFF4DFF9B);
  static const Color neutral = Color(0xFF8A8A8A);

  static const Color divider      = Color(0xFF2A2A2A);
  static const Color borderSubtle = Color(0xFF333333);

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF4DFF9B), Color(0xFF00C9FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF161616)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
