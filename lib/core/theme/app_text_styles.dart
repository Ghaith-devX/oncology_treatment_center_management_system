import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.cairo(
        fontWeight: FontWeight.w400,
      );

  static TextStyle displayLarge = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
  static TextStyle displayMedium = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  static TextStyle displaySmall = _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle headlineLarge = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );
  static TextStyle headlineMedium = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static TextStyle headlineSmall = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleLarge = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static TextStyle titleMedium = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle titleSmall = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyLarge = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodyMedium = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle labelLarge = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle labelMedium = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static TextStyle labelSmall = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get tabular => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
