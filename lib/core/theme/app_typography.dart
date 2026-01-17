import 'package:flutter/material.dart';

import 'app_colors.dart';

/// FoodJury Typography System - "Retro Diner Courtroom"
///
/// Display: Bangers - Chunky, fun, diner-sign energy
/// Body: Nunito - Warm, readable, friendly but not childish
///
/// The typography should feel like a menu board at a classic diner
/// mixed with courtroom drama headlines.
abstract final class AppTypography {
  // ============================================
  // FONT FAMILIES
  // ============================================

  /// Display font - For headlines, verdicts, big moments
  /// Bangers: Bold, chunky, comic-book energy
  static const String displayFont = 'Bangers';

  /// Body font - For readable text, descriptions
  /// Nunito: Warm, rounded, friendly
  static const String bodyFont = 'Nunito';

  // ============================================
  // DISPLAY STYLES - Big, Bold, Unforgettable
  // ============================================

  /// Massive verdict announcements
  /// "PIZZA WINS!"
  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFont,
    fontSize: 48,
    fontWeight: FontWeight.w400, // Bangers only has regular
    height: 1.1,
    letterSpacing: 1.5,
    color: AppColors.textPrimary,
  );

  /// Section headers, screen titles
  /// "THE VERDICT IS IN"
  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFont,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 1.2,
    color: AppColors.textPrimary,
  );

  /// Card titles, prominent labels
  /// "Tonight's Contenders"
  static const TextStyle displaySmall = TextStyle(
    fontFamily: displayFont,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 1.0,
    color: AppColors.textPrimary,
  );

  // ============================================
  // HEADLINE STYLES - Important but not screaming
  // ============================================

  /// Major section headers
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  /// Subsection headers
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  /// Minor headers
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // ============================================
  // TITLE STYLES - UI Element Labels
  // ============================================

  /// App bar titles, dialog headers
  static const TextStyle titleLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  /// Card titles, list item headers
  static const TextStyle titleMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  /// Small titles, chip labels
  static const TextStyle titleSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
  );

  // ============================================
  // BODY STYLES - Readable Content
  // ============================================

  /// Primary body text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
  );

  /// Standard body text
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
  );

  /// Small body text, captions
  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  // ============================================
  // LABEL STYLES - Buttons, Tags, UI Elements
  // ============================================

  /// Primary button text
  static const TextStyle labelLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// Secondary buttons, tabs
  static const TextStyle labelMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// Chips, badges, tiny labels
  static const TextStyle labelSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  // ============================================
  // SPECIAL STYLES
  // ============================================

  /// Verdict stamp text - ALL CAPS, dramatic
  static const TextStyle verdict = TextStyle(
    fontFamily: displayFont,
    fontSize: 56,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 2.0,
    color: AppColors.textInverse,
  );

  /// Food option name on cards
  static const TextStyle foodTitle = TextStyle(
    fontFamily: displayFont,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  /// Judge Bite's speech bubbles
  static const TextStyle judgeSpeech = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Retro diner price tag style
  static const TextStyle priceTag = TextStyle(
    fontFamily: displayFont,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: 0.5,
    color: AppColors.primary,
  );
}
