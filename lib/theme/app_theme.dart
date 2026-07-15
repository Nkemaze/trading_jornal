import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(
          fontSize: 32,
          height: 1.25,
          letterSpacing: -0.02,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          height: 1.33,
          letterSpacing: -0.01,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontSize: 14, height: 1.43, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontSize: 12, height: 1.33, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(
          fontSize: 12,
          height: 1.33,
          letterSpacing: 0.05,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontSize: 11,
          height: 1.27,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        error: AppColors.error,
        onSurface: AppColors.onSurface,
        onError: AppColors.onError,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: baseTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 8,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Custom text styles for specific use cases
  static TextStyle monoData(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 14,
      height: 1.43,
      letterSpacing: -0.01,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    );
  }
}
