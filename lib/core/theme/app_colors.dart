import 'package:flutter/material.dart';

/// FoodJury Color System - "Retro Diner Courtroom"
///
/// A bold, high-contrast palette inspired by 1950s American diners
/// meets courtroom drama. Orange DOMINATES, navy provides punch,
/// mustard yellow sparks highlight moments.
abstract final class AppColors {
  // ============================================
  // PRIMARY - The Star of the Show
  // ============================================

  /// Blazing Orange - DOMINANT color, used generously
  /// Think: Neon diner signs, hot sauce, Judge Bite's passion
  static const Color primary = Color(0xFFFF6B35);

  /// Darker orange for pressed states and depth
  static const Color primaryDark = Color(0xFFE55A2B);

  /// Lighter orange for subtle backgrounds
  static const Color primaryLight = Color(0xFFFF8A5C);

  // ============================================
  // ACCENT - Sharp Contrast
  // ============================================

  /// Deep Navy - Almost black, provides PUNCH
  /// Think: Judge's robe, serious authority, text
  static const Color accent = Color(0xFF1A1A2E);

  /// Slightly lighter for secondary text
  static const Color accentLight = Color(0xFF2D2D44);

  // ============================================
  // POP - Highlight Sparks
  // ============================================

  /// Mustard Yellow - Use SPARINGLY for highlights
  /// Think: Diner booth stitching, star ratings, badges
  static const Color pop = Color(0xFFFFD23F);

  /// Darker mustard for depth
  static const Color popDark = Color(0xFFE5BC38);

  // ============================================
  // BACKGROUND - The Canvas
  // ============================================

  /// Warm Cream - Primary background
  /// Think: Diner menu paper, warm and inviting
  static const Color background = Color(0xFFFFF8F0);

  /// Pure white for cards and elevated surfaces
  static const Color surface = Color(0xFFFFFFFF);

  /// Subtle warm gray for dividers and borders
  static const Color border = Color(0xFFE8E0D8);

  // ============================================
  // SEMANTIC - Verdicts & Feedback
  // ============================================

  /// Victory Green - "The Winner!"
  static const Color success = Color(0xFF2ECC71);

  /// Caution Orange - "Hmm, maybe..."
  static const Color warning = Color(0xFFF39C12);

  /// Rejection Red - "Case Dismissed!"
  static const Color error = Color(0xFFE74C3C);

  /// Info Blue - Neutral information
  static const Color info = Color(0xFF3498DB);

  // ============================================
  // TEXT
  // ============================================

  /// Primary text - Deep navy for readability
  static const Color textPrimary = accent;

  /// Secondary text - Lighter for less emphasis
  static const Color textSecondary = Color(0xFF6B6B80);

  /// Muted text - For hints and placeholders
  static const Color textMuted = Color(0xFF9B9BAF);

  /// Inverse text - For dark backgrounds
  static const Color textInverse = Color(0xFFFFFFFF);

  // ============================================
  // SPECIAL EFFECTS
  // ============================================

  /// Chrome silver - For that diner shine
  static const Color chrome = Color(0xFFC0C0C0);

  /// Chrome highlight
  static const Color chromeLight = Color(0xFFE8E8E8);

  /// Overlay for modals and sheets
  static const Color overlay = Color(0x99000000);

  /// Shadow color
  static const Color shadow = Color(0x29000000);

  // ============================================
  // GRADIENTS
  // ============================================

  /// Primary gradient - Blazing energy
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  /// Verdict stamp gradient - Dramatic entrance
  static const LinearGradient verdictGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, Color(0xFFCC4400)],
  );

  /// Chrome shine gradient - Diner aesthetic
  static const LinearGradient chromeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [chromeLight, chrome, chromeLight],
    stops: [0.0, 0.5, 1.0],
  );

  /// Warm background gradient - Subtle depth
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, Color(0xFFFFF0E0)],
  );
}
