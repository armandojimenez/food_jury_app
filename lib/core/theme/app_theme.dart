import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';
import 'diner_tokens.dart';

/// FoodJury's diner palette, typography and native control defaults.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final paper = dark ? AppColors.backgroundDark : AppColors.background;
    final surface = dark ? AppColors.surfaceDark : AppColors.background;
    final ink = dark ? AppColors.background : AppColors.accent;
    final muted = dark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.accent,
          primaryContainer: dark
              ? AppColors.accentLight
              : AppColors.primaryLight,
          onPrimaryContainer: ink,
          secondary: ink,
          onSecondary: paper,
          tertiary: AppColors.pop,
          onTertiary: AppColors.accent,
          surface: surface,
          onSurface: ink,
          onSurfaceVariant: muted,
          outline: dark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          outlineVariant: dark ? AppColors.borderDark : AppColors.border,
          surfaceContainerHighest: dark
              ? AppColors.borderDark
              : AppColors.border,
          error: dark ? const Color(0xFFFF9A8E) : const Color(0xFFA92E24),
        );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppTypography.bodyFont,
    );
    return base.copyWith(
      scaffoldBackgroundColor: paper,
      textTheme: base.textTheme
          .apply(bodyColor: ink, displayColor: ink)
          .copyWith(
            bodyLarge: TextStyle(
              fontFamily: AppTypography.bodyFont,
              fontSize: 16,
              height: 1.45,
              color: ink,
            ),
            bodyMedium: TextStyle(
              fontFamily: AppTypography.bodyFont,
              fontSize: 14,
              height: 1.4,
              color: ink,
            ),
            titleMedium: TextStyle(
              fontFamily: AppTypography.bodyFont,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
            headlineMedium: TextStyle(
              fontFamily: AppTypography.displayFont,
              fontSize: 32,
              color: ink,
            ),
          ),
      dividerColor: scheme.outlineVariant,
      iconTheme: IconThemeData(color: ink),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          enableFeedback: false,
          foregroundColor: ink,
          minimumSize: const Size(
            DinerTokens.touchTarget,
            DinerTokens.touchTarget,
          ),
          textStyle: const TextStyle(
            fontFamily: AppTypography.bodyFont,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: TextStyle(color: ink),
        hintStyle: TextStyle(color: muted),
        contentPadding: const EdgeInsets.all(AppDimensions.spaceMd),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: BorderSide(color: ink, width: DinerTokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: BorderSide(color: ink, width: DinerTokens.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderThick,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusLg,
          side: BorderSide(color: ink, width: DinerTokens.border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: AppColors.overlay,
        constraints: const BoxConstraints(maxWidth: DinerTokens.sheetWidth),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
          side: BorderSide(color: ink, width: DinerTokens.border),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: ink),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.accent,
        contentTextStyle: TextStyle(
          fontFamily: AppTypography.bodyFont,
          color: AppColors.background,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.accent : surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.pop
              : scheme.surfaceContainerHighest,
        ),
      ),
    );
  }
}
