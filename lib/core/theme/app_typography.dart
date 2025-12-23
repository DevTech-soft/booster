import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system for the app
///

class AppTypography {
  AppTypography._();

  // Font families
  static TextStyle get _primayTextStyle => GoogleFonts.syne();

  static TextStyle get _secundaryTextStyle => GoogleFonts.nunito();

  // Light Theme Typography
  static TextTheme get lightTextTheme => TextTheme(
        // Display styles - Syne font for large titles
        displayLarge: _primayTextStyle.copyWith(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          color: AppColors.textBlack,
        ),
        displayMedium: _primayTextStyle.copyWith(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          color: AppColors.textBlack,
        ),
        displaySmall: _primayTextStyle.copyWith(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textBlack,
        ),

        // Headline styles - Syne font for section headers
        headlineLarge: _primayTextStyle.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textBlack,
        ),
        headlineMedium: _primayTextStyle.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textBlack,
        ),
        headlineSmall: _primayTextStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textBlack,
        ),

        titleLarge: _primayTextStyle.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textBlack,
        ),
        titleMedium: _primayTextStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: AppColors.textBlack,
        ),
        titleSmall: _primayTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: AppColors.textBlack,
        ),

        bodyLarge: _secundaryTextStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: AppColors.textBlack,
        ),
        bodyMedium: _secundaryTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: AppColors.textSecondaryLight,
        ),
        bodySmall: _secundaryTextStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: AppColors.textSecondaryLight,
        ),

        // Label styles - Nunito font for labels, hints, and secondary text
        labelLarge: _secundaryTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimaryLight,
        ),
        labelMedium: _secundaryTextStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textSecondaryLight,
        ),
        labelSmall: _secundaryTextStyle.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textSecondaryLight,
        ),
      );
  // Dark Theme Typography (mirrors light theme)
  static TextTheme get darkTextTheme => TextTheme(
        displayLarge: _primayTextStyle.copyWith(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          color: AppColors.textPrimaryDark,
        ),
        displayMedium: _primayTextStyle.copyWith(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          color: AppColors.textPrimaryDark,
        ),
        displaySmall: _primayTextStyle.copyWith(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textPrimaryDark,
        ),
        headlineLarge: _primayTextStyle.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: _primayTextStyle.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textPrimaryDark,
        ),
        headlineSmall: _primayTextStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: _primayTextStyle.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: _primayTextStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: AppColors.textPrimaryDark,
        ),
        titleSmall: _primayTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: _secundaryTextStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: _secundaryTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: AppColors.textSecondaryDark,
        ),
        bodySmall: _secundaryTextStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: AppColors.textSecondaryDark,
        ),
        labelLarge: _secundaryTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: AppColors.textPrimaryDark,
        ),
        labelMedium: _secundaryTextStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textSecondaryDark,
        ),
        labelSmall: _secundaryTextStyle.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.textSecondaryDark,
        ),
      );

  // ============================================
  // Custom text styles for specific use cases
  // ============================================

  /// Currency styles - Syne font for monetary values
  static TextStyle get currencyLarge => _primayTextStyle.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get currencyMedium => _primayTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      );

  static TextStyle get currencySmall => _primayTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      );

  /// Button styles - Syne font for button text
  static TextStyle get buttonLarge => _primayTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonMedium => _primayTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  /// Caption and overline - Nunito font for small helper text
  static TextStyle get caption => _secundaryTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      );

  static TextStyle get overline => _secundaryTextStyle.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        textBaseline: TextBaseline.alphabetic,
      );

  /// Input field styles - Nunito font for form inputs
  static TextStyle get inputLabel => _primayTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );

  static TextStyle get inputText => _secundaryTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      );

  static TextStyle get inputHint => _secundaryTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: AppColors.textSecondaryLight,
      );

  static TextStyle get inputError => _secundaryTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: AppColors.error,
      );

  /// Link styles - Nunito font for clickable links
  static TextStyle get linkText => _secundaryTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.25,
        decoration: TextDecoration.underline,
      );

  static TextStyle get linkSmall => _secundaryTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        decoration: TextDecoration.underline,
      );
}
