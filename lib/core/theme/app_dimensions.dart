import 'package:flutter/material.dart';

/// FoodJury Dimension System - "Retro Diner Courtroom"
///
/// Generous spacing, chunky borders, bold shadows.
/// Nothing timid - this is a place with PRESENCE.
abstract final class AppDimensions {
  // ============================================
  // SPACING - Generous & Confident
  // ============================================

  /// Micro spacing - Tight elements
  static const double spaceXxs = 2.0;
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double spaceXxl = 48.0;
  static const double spaceXxxl = 64.0;

  /// Screen edge padding - Generous but not wasteful
  static const double screenPaddingHorizontal = 20.0;
  static const double screenPaddingVertical = 24.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenPaddingHorizontal,
    vertical: screenPaddingVertical,
  );

  static const EdgeInsets screenPaddingHorizontalOnly = EdgeInsets.symmetric(
    horizontal: screenPaddingHorizontal,
  );

  // ============================================
  // BORDER RADIUS - Chunky & Friendly
  // ============================================

  /// Subtle rounding
  static const double radiusSm = 8.0;

  /// Standard card rounding - Our default
  static const double radiusMd = 16.0;

  /// Prominent elements
  static const double radiusLg = 24.0;

  /// Pills, fully rounded elements
  static const double radiusXl = 32.0;

  /// Circular
  static const double radiusFull = 999.0;

  /// Standard card border radius
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );

  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );

  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );

  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );

  /// Pill-shaped border radius for badges and chips.
  static const BorderRadius borderRadiusPill = BorderRadius.all(
    Radius.circular(100),
  );

  // ============================================
  // BORDER WIDTH - Bold Lines
  // ============================================

  /// Subtle borders
  static const double borderThin = 1.0;

  /// Standard borders
  static const double borderMedium = 2.0;

  /// Chunky retro borders - Diner menu style
  static const double borderThick = 3.0;

  /// Extra chunky for special elements
  static const double borderChunky = 4.0;

  // ============================================
  // SHADOWS - Dramatic Depth
  // ============================================

  /// Subtle elevation - Resting state
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Medium elevation - Cards, buttons
  static const List<BoxShadow> shadowMd = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  /// High elevation - Modals, floating elements
  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x29000000), blurRadius: 16, offset: Offset(0, 8)),
  ];

  /// Dramatic - Verdict cards, hero elements
  static const List<BoxShadow> shadowXl = [
    BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 12)),
  ];

  /// Retro hard shadow - Diner sign style (no blur!)
  static const List<BoxShadow> shadowRetro = [
    BoxShadow(color: Color(0xFF1A1A2E), blurRadius: 0, offset: Offset(4, 4)),
  ];

  /// Retro hard shadow - Smaller version
  static const List<BoxShadow> shadowRetroSm = [
    BoxShadow(color: Color(0xFF1A1A2E), blurRadius: 0, offset: Offset(2, 2)),
  ];

  /// Gold glow shadow - For highlights and emphasis (mustard yellow)
  static const List<BoxShadow> shadowGlow = [
    BoxShadow(color: Color(0x4DFFD23F), blurRadius: 12, spreadRadius: 2),
  ];

  /// Combined retro + glow for hero elements
  static const List<BoxShadow> shadowRetroGlow = [
    BoxShadow(color: Color(0xFF1A1A2E), blurRadius: 0, offset: Offset(4, 4)),
    BoxShadow(color: Color(0x33FFD23F), blurRadius: 16, spreadRadius: 0),
  ];

  // ============================================
  // COMPONENT SIZES
  // ============================================

  /// Button heights
  static const double buttonHeightSm = 40.0;
  static const double buttonHeightMd = 52.0;
  static const double buttonHeightLg = 60.0;

  /// Icon sizes
  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;

  /// Icon container sizes (for circular icon backgrounds)
  static const double iconContainerSm = 32.0;
  static const double iconContainerMd = 40.0;
  static const double iconContainerLg = 56.0;

  /// Bottom sheet specific radius
  static const double bottomSheetRadius = 20.0;

  /// Avatar/profile sizes
  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 48.0;
  static const double avatarSizeLg = 64.0;
  static const double avatarSizeXl = 96.0;

  /// Food card dimensions
  static const double foodCardMinHeight = 120.0;
  static const double foodCardImageSize = 80.0;

  /// Judge Bite sizes
  static const double judgeBiteSm = 60.0;
  static const double judgeBiteMd = 100.0;
  static const double judgeBiteLg = 160.0;
  static const double judgeBiteXl = 220.0;

  /// Bottom sheet drag handle
  static const double dragHandleWidth = 40.0;
  static const double dragHandleHeight = 4.0;

  // ============================================
  // ANIMATION DURATIONS
  // ============================================

  /// Micro interactions - Hover, press
  static const Duration durationFast = Duration(milliseconds: 150);

  /// Standard transitions
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// Elaborate animations
  static const Duration durationSlow = Duration(milliseconds: 500);

  /// Dramatic reveals - Verdicts!
  static const Duration durationDramatic = Duration(milliseconds: 800);

  /// Page transitions
  static const Duration durationPage = Duration(milliseconds: 350);

  // ============================================
  // ANIMATION CURVES
  // ============================================

  /// Snappy micro-interactions
  static const Curve curveSnappy = Curves.easeOutCubic;

  /// Smooth standard transitions
  static const Curve curveSmooth = Curves.easeInOutCubic;

  /// Bouncy playful animations
  static const Curve curveBouncy = Curves.elasticOut;

  /// Dramatic entrance
  static const Curve curveDramatic = Curves.easeOutBack;

  /// Anticipation (pull back then release)
  static const Curve curveAnticipate = Curves.easeInBack;

  // ============================================
  // SPECIAL VALUES
  // ============================================

  /// Verdict card tilt angle (in radians, ~3 degrees)
  static const double verdictTiltAngle = 0.052;

  /// Food card slight tilt for stacked effect
  static const double cardStackTilt = 0.02;

  /// Gavel slam scale factor
  static const double gavelSlamScale = 1.15;

  /// Screen shake offset
  static const double screenShakeOffset = 8.0;
}
