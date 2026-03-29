import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static final ThemeData lightTheme = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    final TextTheme textTheme = AppTypography.getTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.inverseSurface,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: textTheme,
      cardTheme: const CardTheme(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        space: 24,
        thickness: 0,
        color: Colors.transparent, // Disable 1px lines as per rules
      ),
    );
  }
}
