# GitHub Copilot Instructions for FoodJury

**Master Instructions**: [`../INSTRUCTIONS.md`](../INSTRUCTIONS.md) - Read this file!

## Quick Rules

1. **Zero analyzer errors** - Code must pass `flutter analyze`
2. **Design tokens only** - Use `AppColors.*`, `AppTypography.*`, `AppDimensions.*`
3. **Riverpod 3.0** - Use `@riverpod` with `Notifier`/`AsyncNotifier`
4. **Document APIs** - All public members need doc comments
5. **Accessibility** - WCAG AA compliance (contrast, tap targets, semantics)

## Design Tokens

```dart
// Colors
AppColors.primary, AppColors.accent, AppColors.pop

// Typography  
AppTypography.displayLarge, AppTypography.bodyLarge

// Spacing
AppDimensions.spaceMd, AppDimensions.spaceLg

// Borders
AppDimensions.borderThick, AppDimensions.borderRadiusMd
```

## Components

Import: `import 'package:food_jury_app/core/widgets/widgets.dart';`

Available: `AppButton`, `AppCard`, `FoodCard`, `VerdictCard`, `AppTextField`, `AppSnackbar`, `AppDialog`, `LoadingOverlay`, `JudgeBite`, etc.

## Common Patterns

```dart
// Async with context
if (!mounted) return;

// Error handling
try { await action(); } catch (e) { showError(e); }

// Const everywhere
const SizedBox(height: AppDimensions.spaceMd)
```

---

**Full details in [`INSTRUCTIONS.md`](../INSTRUCTIONS.md)** ⚖️
