import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0D7C6E);
  static const Color primaryLight = Color(0xFF4DB6AC);
  static const Color primaryDark = Color(0xFF00695C);

  static const Color secondary = Color(0xFF5C6BC0);
  static const Color secondaryLight = Color(0xFF8E99D6);
  static const Color secondaryDark = Color(0xFF3949AB);

  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA726);
  static const Color danger = Color(0xFFEF5350);
  static const Color info = Color(0xFF29B6F6);

  static const Color surfaceLight = Color(0xFFF5F7FA);
  static const Color surfaceDark = Color(0xFF1A1E24);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF252A32);

  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFE8E8E8);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  static const Color scaffoldBgLight = Color(0xFFF5F7FA);
  static const Color scaffoldBgDark = Color(0xFF12161B);
}

class AppSemanticColors {
  AppSemanticColors._();

  static Color success = AppColors.success;
  static Color warning = AppColors.warning;
  static Color danger = AppColors.danger;
  static Color info = AppColors.info;
}

class LightColors {
  LightColors._();

  static const Color primary = AppColors.primary;
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFB2DFDB);
  static const Color onPrimaryContainer = Color(0xFF00251E);

  static const Color secondary = AppColors.secondary;
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFC5CAE9);
  static const Color onSecondaryContainer = Color(0xFF1A237E);

  static const Color surface = AppColors.cardLight;
  static const Color onSurface = AppColors.textPrimaryLight;
  static const Color surfaceVariant = AppColors.surfaceLight;
  static const Color onSurfaceVariant = AppColors.textSecondaryLight;

  static const Color error = AppColors.danger;
  static const Color onError = Colors.white;
  static const Color outline = AppColors.borderLight;
  static const Color scaffoldBg = AppColors.scaffoldBgLight;
}

class DarkColors {
  DarkColors._();

  static const Color primary = AppColors.primaryLight;
  static const Color onPrimary = Color(0xFF00392E);
  static const Color primaryContainer = Color(0xFF005144);
  static const Color onPrimaryContainer = Color(0xFFB2DFDB);

  static const Color secondary = AppColors.secondaryLight;
  static const Color onSecondary = Color(0xFF1A237E);
  static const Color secondaryContainer = Color(0xFF283593);
  static const Color onSecondaryContainer = Color(0xFFC5CAE9);

  static const Color surface = AppColors.cardDark;
  static const Color onSurface = AppColors.textPrimaryDark;
  static const Color surfaceVariant = AppColors.surfaceDark;
  static const Color onSurfaceVariant = AppColors.textSecondaryDark;

  static const Color error = Color(0xFFEF9A9A);
  static const Color onError = Color(0xFF690005);
  static const Color outline = AppColors.borderDark;
  static const Color scaffoldBg = AppColors.scaffoldBgDark;
}
