# FoodJury

A food decision app set in a retro diner courtroom. Bring 2–5 contenders, add optional photos and notes, choose a goal, and let Judge Bite deliver a saved verdict.

## Current app

The October 2026 redesign includes all app screens, twelve expressive judge poses, illustrated food fallbacks, a new app icon, the developer's illustrated portrait, tablet/landscape layouts, English/Spanish, dark mode, and a replayable verdict reveal with reduced-motion support.

Lucky Court adds four free animated rituals, 44 bilingual judge sayings, explicit save/replay, and a searchable illustrated food menu. Three welcome Smart rulings are tracked separately from history deletion.

The existing camera/gallery and reasoned photo-analysis flow remains intact. App illustrations are decorative; they never become AI evidence. User photos take precedence wherever a food option appears.

## Run

```sh
flutter pub get
flutter run

# Offline design preview: separate in-memory history and simulated AI.
flutter run -t lib/main_preview.dart

# Open a specific preview screen.
flutter run -t lib/main_preview.dart --dart-define=PREVIEW_ROUTE=/decision/verdict
```

Preview routes also accept `methods`, `library`, `lucky`, `wheel`, `ticket`, `cloche`, `coin`, `plus`, and `new`. The preview defaults to English; `--dart-define=PREVIEW_LOCALE=es` selects Spanish. Debug-only `ext.foodjury.preview` navigation is registered only by this preview entry point.

Normal app entry points retain Firebase and the existing persistent database. The preview entry point never writes to real case history.

## Verify

```sh
flutter analyze
flutter test
flutter test --dart-define=UPDATE_DESIGN_PREVIEWS=true
flutter build ios --simulator --debug --no-codesign
flutter build apk --debug
```

The tests cover all screens on phone, tablet, landscape, dark mode, and a small Spanish screen at 200% text size, plus the full case/photo/save/reveal flow. Generated render captures live in `design/verification/`; native simulator captures are prefixed `native-`.

## Design and implementation

- [DESIGN.md](DESIGN.md): tokens, composition, components, responsive behavior, motion, accessibility, and a new-screen recipe.
- [JUDGE_BITE_MASCOT_SPEC.md](JUDGE_BITE_MASCOT_SPEC.md): anatomy, ten poses, expressions, and future artwork rules.
- [Production asset prompts](design/production/prompts.json) and [developer portrait prompt](design/production/developer-portrait-prompt.txt).
- [Verification record](design/verification/README.md): actual checks, screenshots, and limits.
- [INSTRUCTIONS.md](INSTRUCTIONS.md): repository coding conventions.
- [PLAN.md](PLAN.md): current status followed by the historical roadmap.

The living component and pose gallery is **Settings → Developer options → Design kitchen** in development mode. New screens should compose the shared `Diner*` widgets from `lib/core/widgets/` and use tokens from `lib/core/theme/`.

## Deliberately pending

Billing is a **price preview**, as requested: $24.99/year or $5.99/month. There are no real purchases, restore flow, or verified premium entitlements yet. The three welcome Smart rulings are enforced locally; account/server enforcement across reinstalls and devices remains to be connected. The approved onboarding is still a design prototype. See the exact integration checklist in [DESIGN.md](DESIGN.md#billing-intentionally-unfinished).

## Stack

Flutter / Dart, Riverpod 2.6 with Notifier providers, GoRouter, Drift/SQLite, Firebase AI Logic, image_picker, and share_plus. This redesign was validated with Flutter 3.41.7 and Dart 3.11.5; `pubspec.lock` records the resolved dependencies.

The app is private and not yet live. Historical phase documents describe earlier milestones and are not the current design specification.
