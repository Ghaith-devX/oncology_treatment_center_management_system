import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: LightColors.primary,
        onPrimary: LightColors.onPrimary,
        primaryContainer: LightColors.primaryContainer,
        onPrimaryContainer: LightColors.onPrimaryContainer,
        secondary: LightColors.secondary,
        onSecondary: LightColors.onSecondary,
        secondaryContainer: LightColors.secondaryContainer,
        onSecondaryContainer: LightColors.onSecondaryContainer,
        surface: LightColors.surface,
        onSurface: LightColors.onSurface,
        surfaceContainerHighest: LightColors.surfaceVariant,
        onSurfaceVariant: LightColors.onSurfaceVariant,
        error: LightColors.error,
        onError: LightColors.onError,
        outline: LightColors.outline,
      ),
      scaffoldBackgroundColor: LightColors.scaffoldBg,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: LightColors.onSurface,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: LightColors.onSurface,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: LightColors.onSurface,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: LightColors.onSurface,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: LightColors.onSurface,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: LightColors.onSurface,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: LightColors.onSurface,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: LightColors.onSurfaceVariant,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: LightColors.onSurfaceVariant,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: LightColors.onSurface,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: LightColors.onSurfaceVariant,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: LightColors.onSurfaceVariant,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: LightColors.onSurface,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: LightColors.onSurfaceVariant,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: LightColors.onSurfaceVariant,
        ),
      ),
      cardTheme: CardThemeData(
        color: LightColors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LightColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: LightColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: LightColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: LightColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: LightColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LightColors.primary,
          foregroundColor: LightColors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: LightColors.onPrimary,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: LightColors.surface,
        foregroundColor: LightColors.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(
        color: LightColors.outline.withValues(alpha: 0.5),
        space: 1,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: DarkColors.primary,
        onPrimary: DarkColors.onPrimary,
        primaryContainer: DarkColors.primaryContainer,
        onPrimaryContainer: DarkColors.onPrimaryContainer,
        secondary: DarkColors.secondary,
        onSecondary: DarkColors.onSecondary,
        secondaryContainer: DarkColors.secondaryContainer,
        onSecondaryContainer: DarkColors.onSecondaryContainer,
        surface: DarkColors.surface,
        onSurface: DarkColors.onSurface,
        surfaceContainerHighest: DarkColors.surfaceVariant,
        onSurfaceVariant: DarkColors.onSurfaceVariant,
        error: DarkColors.error,
        onError: DarkColors.onError,
        outline: DarkColors.outline,
      ),
      scaffoldBackgroundColor: DarkColors.scaffoldBg,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: DarkColors.onSurface,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: DarkColors.onSurface,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: DarkColors.onSurface,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: DarkColors.onSurface,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: DarkColors.onSurface,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: DarkColors.onSurface,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: DarkColors.onSurface,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: DarkColors.onSurfaceVariant,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: DarkColors.onSurfaceVariant,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: DarkColors.onSurface,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: DarkColors.onSurfaceVariant,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: DarkColors.onSurfaceVariant,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: DarkColors.onSurface,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: DarkColors.onSurfaceVariant,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: DarkColors.onSurfaceVariant,
        ),
      ),
      cardTheme: CardThemeData(
        color: DarkColors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DarkColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DarkColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DarkColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: DarkColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DarkColors.primary,
          foregroundColor: DarkColors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: DarkColors.onPrimary,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DarkColors.surface,
        foregroundColor: DarkColors.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(
        color: DarkColors.outline.withValues(alpha: 0.5),
        space: 1,
      ),
    );
  }
}
