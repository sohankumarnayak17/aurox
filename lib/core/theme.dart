import 'package:flutter/material.dart';
import 'colors.dart';
import 'constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.scaffoldBg,
      elevation: 0,
      titleTextStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      iconTheme: IconThemeData(color: AppColors.textSecondary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        borderSide: const BorderSide(color: AppColors.borderSubtle, width: 0.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        borderSide: const BorderSide(color: AppColors.borderSubtle, width: 0.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        borderSide: const BorderSide(color: AppColors.expense, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMD)),
        minimumSize: const Size(double.infinity, 54),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceMid,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD)),
      contentTextStyle:
          const TextStyle(color: AppColors.textPrimary, fontSize: 14),
    ),
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0D0D0D),
      surface: Colors.white,
      onSurface: Color(0xFF0D0D0D),
    ),
  );
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headingLarge = TextStyle(
      fontSize: 28, fontWeight: FontWeight.w700,
      color: AppColors.textPrimary, letterSpacing: -0.5);

  static const TextStyle headingMedium = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static const TextStyle headingSmall = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static const TextStyle bodyLarge = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary);

  static const TextStyle bodyMedium = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary);

  static const TextStyle bodySmall = TextStyle(
      fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textMuted);

  static const TextStyle label = TextStyle(
      fontSize: 11, fontWeight: FontWeight.w600,
      color: AppColors.textMuted, letterSpacing: 0.8);

  static const TextStyle labelCaps = TextStyle(
      fontSize: 10, fontWeight: FontWeight.w600,
      color: AppColors.textMuted, letterSpacing: 1.2);

  static const TextStyle amountLarge = TextStyle(
      fontSize: 36, fontWeight: FontWeight.w700,
      color: AppColors.textPrimary, letterSpacing: -1);

  static const TextStyle amountMedium = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary);

  static const TextStyle amountExpense = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.expense);

  static const TextStyle amountIncome = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.income);

  static const TextStyle tabActive = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  static const TextStyle tabInactive = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textMuted);

  static const TextStyle cardNumber = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w600,
      color: AppColors.textOnCard, letterSpacing: 2);

  static const TextStyle cardHolder = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textOnCard);
}

class AppDecorations {
  AppDecorations._();

  static BoxDecoration darkCard({double radius = AppConstants.radiusLG}) =>
      BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.borderSubtle, width: 0.8),
      );

  static BoxDecoration whiteCard({double radius = AppConstants.radiusLG}) =>
      BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(radius),
      );

  static const BoxDecoration transactionIcon = BoxDecoration(
    color: AppColors.surfaceMid,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );
}
