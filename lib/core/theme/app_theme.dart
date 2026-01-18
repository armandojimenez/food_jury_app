import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

/// FoodJury Theme - "Retro Diner Courtroom"
///
/// Assembles colors, typography, and dimensions into
/// a cohesive Material theme with custom extensions.
abstract final class AppTheme {
  /// Light theme - Primary theme for the app
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textInverse,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.accent,
        secondary: AppColors.accent,
        onSecondary: AppColors.textInverse,
        secondaryContainer: AppColors.accentLight,
        onSecondaryContainer: AppColors.textInverse,
        tertiary: AppColors.pop,
        onTertiary: AppColors.accent,
        tertiaryContainer: AppColors.popDark,
        onTertiaryContainer: AppColors.accent,
        error: AppColors.error,
        onError: AppColors.textInverse,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.background,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.border,
        outlineVariant: AppColors.border,
        shadow: AppColors.shadow,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // App bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        displaySmall: AppTypography.displaySmall,
        headlineLarge: AppTypography.headlineLarge,
        headlineMedium: AppTypography.headlineMedium,
        headlineSmall: AppTypography.headlineSmall,
        titleLarge: AppTypography.titleLarge,
        titleMedium: AppTypography.titleMedium,
        titleSmall: AppTypography.titleSmall,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
            vertical: AppDimensions.spaceMd,
          ),
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMd,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            color: AppColors.textInverse,
          ),
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
            vertical: AppDimensions.spaceMd,
          ),
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMd,
          ),
          side: const BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderMedium,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: AppDimensions.spaceSm,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceMd,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderMedium,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderMedium,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: AppDimensions.borderThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderMedium,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderThick,
          ),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textMuted,
        ),
        labelStyle: AppTypography.bodyMedium,
        errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          side: const BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderMedium,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Bottom sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
        ),
        dragHandleColor: AppColors.border,
        dragHandleSize: Size(
          AppDimensions.dragHandleWidth,
          AppDimensions.dragHandleHeight,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.titleLarge,
        contentTextStyle: AppTypography.bodyMedium,
      ),

      // Floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppDimensions.iconSizeMd,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: AppDimensions.borderThin,
        space: AppDimensions.spaceMd,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.accent,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textInverse,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        labelStyle: AppTypography.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusSm,
          side: const BorderSide(
            color: AppColors.border,
            width: AppDimensions.borderThin,
          ),
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textInverse;
          }
          return AppColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.border;
        }),
      ),

      // Progress indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.border,
        circularTrackColor: AppColors.border,
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // Visual density
      visualDensity: VisualDensity.standard,

      // Splash factory
      splashFactory: InkSparkle.splashFactory,
    );
  }

  /// Dark theme - Alternative theme for dark mode
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.accent,
        primaryContainer: AppColors.primary,
        onPrimaryContainer: AppColors.textInverse,
        secondary: AppColors.textPrimaryDark,
        onSecondary: AppColors.accent,
        secondaryContainer: AppColors.surfaceDark,
        onSecondaryContainer: AppColors.textPrimaryDark,
        tertiary: AppColors.pop,
        onTertiary: AppColors.accent,
        tertiaryContainer: AppColors.popDark,
        onTertiaryContainer: AppColors.accent,
        error: AppColors.error,
        onError: AppColors.textInverse,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.backgroundDark,
        onSurfaceVariant: AppColors.textSecondaryDark,
        outline: AppColors.borderDark,
        outlineVariant: AppColors.borderDark,
        shadow: AppColors.shadowDark,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // App bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleSmall: AppTypography.titleSmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        labelMedium: AppTypography.labelMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
            vertical: AppDimensions.spaceMd,
          ),
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMd,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            color: AppColors.textInverse,
          ),
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
            vertical: AppDimensions.spaceMd,
          ),
          minimumSize: const Size(
            double.infinity,
            AppDimensions.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusMd,
          ),
          side: const BorderSide(
            color: AppColors.primaryLight,
            width: AppDimensions.borderMedium,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: AppDimensions.spaceSm,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceMd,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.borderDark,
            width: AppDimensions.borderMedium,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.borderDark,
            width: AppDimensions.borderMedium,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.primaryLight,
            width: AppDimensions.borderThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderMedium,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderThick,
          ),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textMutedDark,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
          side: const BorderSide(
            color: AppColors.borderDark,
            width: AppDimensions.borderMedium,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Bottom sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
        ),
        dragHandleColor: AppColors.borderDark,
        dragHandleSize: Size(
          AppDimensions.dragHandleWidth,
          AppDimensions.dragHandleHeight,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusLg,
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),

      // Floating action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size: AppDimensions.iconSizeMd,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: AppDimensions.borderThin,
        space: AppDimensions.spaceMd,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceDark,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusSm,
          side: const BorderSide(
            color: AppColors.borderDark,
            width: AppDimensions.borderThin,
          ),
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textInverse;
          }
          return AppColors.textMutedDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.borderDark;
        }),
      ),

      // Progress indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryLight,
        linearTrackColor: AppColors.borderDark,
        circularTrackColor: AppColors.borderDark,
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      // Visual density
      visualDensity: VisualDensity.standard,

      // Splash factory
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
