// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF4FC3F7);
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentSecondary = Color(0xFF00C896);

  // Light theme
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0D1117);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);

  // Dark theme
  static const Color backgroundDark = Color(0xFF0A0E1A);
  static const Color surfaceDark = Color(0xFF141824);
  static const Color cardDark = Color(0xFF1E2336);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);
  static const Color dividerDark = Color(0xFF2D3748);
  static const Color shimmerBaseDark = Color(0xFF2D3748);
  static const Color shimmerHighlightDark = Color(0xFF3D4A5C);

  // Category colors
  static const Color techColor = Color(0xFF6C63FF);
  static const Color sportsColor = Color(0xFF00C896);
  static const Color businessColor = Color(0xFFFF6B35);
  static const Color healthColor = Color(0xFFE91E8C);
  static const Color scienceColor = Color(0xFF00BCD4);
  static const Color entColor = Color(0xFFFFB300);
  static const Color generalColor = Color(0xFF78909C);
  static const Color breakingColor = Color(0xFFE53E3E);
}

class AppTheme {
  AppTheme._();

  static TextTheme _buildTextTheme(bool isDark) {
    final Color primary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final Color secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32, fontWeight: FontWeight.w700, color: primary, height: 1.2,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 28, fontWeight: FontWeight.w700, color: primary, height: 1.2,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 24, fontWeight: FontWeight.w600, color: primary, height: 1.3,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 22, fontWeight: FontWeight.w700, color: primary, height: 1.3,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 20, fontWeight: FontWeight.w600, color: primary, height: 1.4,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 18, fontWeight: FontWeight.w600, color: primary, height: 1.4,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 17, fontWeight: FontWeight.w600, color: primary, height: 1.4,
      ),
      titleMedium: GoogleFonts.spaceGrotesk(
        fontSize: 15, fontWeight: FontWeight.w600, color: primary, height: 1.4,
      ),
      titleSmall: GoogleFonts.spaceGrotesk(
        fontSize: 13, fontWeight: FontWeight.w600, color: primary, height: 1.4,
      ),
      bodyLarge: GoogleFonts.sourceSerif4(
        fontSize: 16, fontWeight: FontWeight.w400, color: primary, height: 1.6,
      ),
      bodyMedium: GoogleFonts.sourceSerif4(
        fontSize: 14, fontWeight: FontWeight.w400, color: primary, height: 1.6,
      ),
      bodySmall: GoogleFonts.spaceGrotesk(
        fontSize: 12, fontWeight: FontWeight.w400, color: secondary, height: 1.5,
      ),
      labelLarge: GoogleFonts.spaceGrotesk(
        fontSize: 14, fontWeight: FontWeight.w600, color: primary, letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.spaceGrotesk(
        fontSize: 12, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 0.3,
      ),
      labelSmall: GoogleFonts.spaceGrotesk(
        fontSize: 10, fontWeight: FontWeight.w500, color: secondary, letterSpacing: 0.5,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surfaceLight,
        background: AppColors.backgroundLight,
        error: AppColors.breakingColor,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _buildTextTheme(false),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.dividerLight,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.dividerLight, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiaryLight,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.textTertiaryLight,
          fontSize: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundLight,
        selectedColor: AppColors.primary,
        labelStyle: GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: AppColors.dividerLight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.accent,
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundDark,
        error: AppColors.breakingColor,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _buildTextTheme(true),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.dividerDark,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.dividerDark, width: 1),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textTertiaryDark,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.textTertiaryDark,
          fontSize: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardDark,
        selectedColor: AppColors.primary,
        labelStyle: GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: AppColors.dividerDark),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
