import 'package:flutter/material.dart';

/// Layout and motion tokens for the approved diner design.
abstract final class DinerTokens {
  /// Maximum width of the complete content composition.
  static const double contentWidth = 1120;

  /// Maximum width of prose and archive screens.
  static const double readingWidth = 620;

  /// Available content width needed for two columns.
  static const double tabletBreakpoint = 760;

  /// Text scale where decorative overlap and columns simplify.
  static const double largeTextBreakpoint = 1.5;

  /// Short windows keep primary actions in the scroll flow.
  static const double compactWindowHeight = 600;

  /// Horizontal and vertical inset of a diner page.
  static const double pageInset = 20;

  /// Space between primary and supporting tablet columns.
  static const double columnGap = 40;

  /// Minimum masthead height, excluding the safe area and trim.
  static const double headerHeight = 82;

  /// Edge length of each checkerboard square.
  static const double checkerSize = 10;

  /// Minimum dimension for an interactive target.
  static const double touchTarget = 48;

  /// Minimum height of primary diner actions.
  static const double buttonHeight = 60;

  /// Standard prominent mascot size.
  static const double heroJudge = 242;

  /// Prominent mascot size in wide layouts.
  static const double tabletJudge = 340;

  /// Portrait size for the maker’s overlapping diner poster.
  static const double makerPortrait = 280;

  /// Judge illustration that spills over a ruling ticket.
  static const double rulingJudge = 132;

  /// Space reserved beside the ruling illustration.
  static const double rulingInset = 108;

  /// Compact artwork in saved-case rows.
  static const double historyThumbnail = 68;

  /// Inline photo preview height in the option sheet.
  static const double photoPreview = 160;

  /// Maximum decoded width of a picker preview.
  static const int photoDecodeWidth = 1000;

  /// Width of appearance options in a wrapping group.
  static const double appearanceChoice = 130;

  /// Width of the splash wordmark.
  static const double splashWordmark = 350;

  /// Width of the splash checker strip.
  static const double splashTrim = 260;

  /// Phone character scene's maximum size.
  static const double sceneJudge = 260;

  /// Tablet character scene's maximum size.
  static const double wideSceneJudge = 370;

  /// Maximum speech bubble width.
  static const double bubbleWidth = 150;

  /// Padding around speech bubble copy.
  static const double bubbleInset = 12;

  /// Speech bubble letter size.
  static const double bubbleType = 15;

  /// Default comic accent ray extent.
  static const double rays = 54;

  /// Tighter accent rays beside a character.
  static const double smallRays = 45;

  /// Fine outline on a floating dismiss badge.
  static const double badgeBorder = 1.5;

  /// Padding inside the visible dismiss badge, separate from its hit area.
  static const double badgeInset = 3;

  /// Food option artwork size.
  static const double thumbnail = 84;

  /// Maximum width of utility sheets.
  static const double sheetWidth = 580;

  /// Main diner outline weight.
  static const double border = 2.5;

  /// Main diner corner radius.
  static const double radius = 16;

  /// Hard shadow offset for raised controls.
  static const double shadow = 4;

  /// Emphasized supporting copy beside major actions.
  static const double bodyEmphasis = 18;

  /// Phone display headline size.
  static const double headline = 40;

  /// Compact heading hierarchy at large text; still uses the full system scale.
  static const double accessibleHeadline = 28;

  /// Wide-layout display headline size.
  static const double tabletHeadline = 56;

  /// Masthead sign letter size.
  static const double signSize = 36;

  /// Bangers action label size.
  static const double buttonType = 25;

  /// Section divider letter size.
  static const double sectionType = 23;

  /// Tilted stamp letter size.
  static const double stampType = 25;

  /// Press and release travel time.
  static const Duration press = Duration(milliseconds: 120);

  /// Default content entrance time.
  static const Duration entrance = Duration(milliseconds: 480);

  /// Delay between related content entrances.
  static const Duration stagger = Duration(milliseconds: 70);

  /// Page transition time.
  static const Duration route = Duration(milliseconds: 380);

  /// One character breathing cycle.
  static const Duration idle = Duration(milliseconds: 2600);

  /// Complete verdict suspense and reveal time.
  static const Duration reveal = Duration(milliseconds: 1900);

  /// Finite celebration particle lifetime.
  static const Duration confetti = Duration(milliseconds: 1800);

  /// Finite success-only stamp after a case has been saved.
  static const Duration filingStamp = Duration(milliseconds: 740);

  /// Easing used for entering content.
  static const Curve enterCurve = Curves.easeOutCubic;

  /// Restrained overshoot used at key moments.
  static const Curve bounceCurve = Curves.easeOutBack;
}
