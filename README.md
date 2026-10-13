# FoodJury

A food decision app set in a retro diner courtroom. Bring 2–5 contenders, add optional photos and notes, choose a goal, and let Judge Bite deliver a saved verdict.

## Current app

The October 2026 redesign includes all app screens, eighteen expressive judge poses, illustrated food fallbacks, a new app icon, the developer's illustrated portrait, tablet/landscape layouts, English/Spanish, dark mode, and a replayable verdict reveal with reduced-motion support.

Lucky Court adds four unlimited, free animated rituals, 68 bilingual judge sayings, explicit save/replay, and a searchable 54-choice food menu backed by 43 illustrations, including breakfast, takeout, sweets, and Latin favorites. Three welcome Smart rulings are tracked separately from history deletion and mirrored to persistent platform storage.

The next chapter adds a hands-on onboarding verdict, optional evidence preview, personality selection, pass-the-phone Jury Duty, resumable case drafts, named favorite lineups, quick multi-select food entry, searchable history, Objection actions, shareable image receipts, and optional post-meal feedback. Judge Bite now has 55 contextual asides, six new poses within the eighteen-pose set, a finite filing stamp, and sound/haptic preferences.

The existing camera/gallery and reasoned photo-analysis flow remains intact. App illustrations are decorative; they never become AI evidence. User photos take precedence wherever a food option appears.

## Run

```sh
flutter pub get
flutter run -t lib/main_dev.dart --dart-define-from-file=config/dev.local.json
flutter run -t lib/main_prod.dart --dart-define-from-file=config/prod.local.json

# Offline design preview: separate in-memory history and simulated AI.
flutter run -t lib/main_preview.dart

# Open a specific preview screen.
flutter run -t lib/main_preview.dart --dart-define=PREVIEW_ROUTE=/decision/verdict
```

Preview routes also accept `methods`, `library`, `lucky`, `wheel`, `ticket`, `cloche`, `coin`, `plus`, `new`, `welcome`, and `jury`. The preview defaults to English; `--dart-define=PREVIEW_LOCALE=es` selects Spanish. Debug-only `ext.foodjury.preview` navigation is registered only by this preview entry point.

Normal entry points use the persistent database and the HTTP AI gateway client. `main.dart` selects development; `main_dev.dart` and `main_prod.dart` explicitly select the matching environment. The ignored local define file supplies `AI_GATEWAY_URL` and the matching `AI_GATEWAY_TOKEN`; real Smart requests require valid gateway configuration. Missing configuration leaves Lucky Court available. See [gateway setup](tool/gateway/README.md#local-build-configuration) for configuration generation; never commit or display the private define files. Preview history, Smart allowance and AI permission use separate in-memory stores, with simulated AI.

## Smart requests and privacy

Firebase AI and Firebase initialization have been removed. `AiGatewayService` sends real Smart requests through the owner's Cloudflare AI gateway, with model routing and the Judge Bite prompt controlled by the gateway. The deployed dev/prod configurations specify OpenRouter providers with zero data retention, data collection denied and reasoning disabled; model order, host restrictions and request limits are documented in [the gateway contract](tool/gateway/README.md). The verification record includes passing live dev/prod requests and native acceptance checks.

Before the first real Smart request, a versioned permission sheet explains the case data and recipients. Settings can review or withdraw permission. The request contains the goal, tone, locale, contender names/notes, actual optional photos and a random app identity; decorative illustrations are never sent. The client validates the complete ranking before saving. Rate limits, filtered cases, oversized evidence, missing configuration and network failures keep the case available for retry or Lucky Court.

The allowance stores only a random UUID and charged operation IDs alongside the SQLite usage ledger. Apple uses Keychain; Android uses backup-eligible preferences (DataStore). Reconciliation never refunds recorded uses, history deletion does not reset them, and failed AI or database saves do not consume a use. If mirroring a committed result fails, retry returns that same result without generating or charging again. Unreadable or corrupt storage blocks Smart until it can be verified, while Lucky Court remains usable.

This provides local reinstall resistance, not account-level or tamper-proof enforcement. Android recovery depends on OS/user backup, and loss of both stores or a device reset can reset local state. SQLite and platform storage cannot commit atomically; an interrupted mirror is repaired from the database while it still exists.

## Verify

```sh
flutter analyze
flutter test
flutter test --dart-define=UPDATE_DESIGN_PREVIEWS=true
flutter build ios --simulator --debug --no-codesign -t lib/main_dev.dart --dart-define-from-file=config/dev.local.json
flutter build apk --debug -t lib/main_dev.dart --dart-define-from-file=config/dev.local.json
```

The tests cover all screens on phone, tablet, landscape, dark mode, and a small Spanish screen at 200% text size, plus the full case/photo/save/reveal flow. Generated render captures live in `design/verification/`; native simulator captures are prefixed `native-`.

## Design and implementation

- [DESIGN.md](DESIGN.md): tokens, composition, components, responsive behavior, motion, accessibility, and a new-screen recipe.
- [JUDGE_BITE_MASCOT_SPEC.md](JUDGE_BITE_MASCOT_SPEC.md): anatomy, eighteen poses, expressions, and future artwork rules.
- [Next-chapter artwork prompts and source manifest](design/production/next-chapter/prompts.json).
- [Production asset prompts](design/production/prompts.json) and [developer portrait prompt](design/production/developer-portrait-prompt.txt).
- [Verification record](design/verification/README.md): actual checks, screenshots, and limits.
- [AI gateway contract and build configuration](tool/gateway/README.md).
- [Firebase App Distribution prerequisites and current blockers](tool/distribution/README.md).
- [INSTRUCTIONS.md](INSTRUCTIONS.md): repository coding conventions.
- [PLAN.md](PLAN.md): current status followed by the historical roadmap.

The living component and pose gallery is **Settings → Developer options → Design kitchen** in development mode. New screens should compose the shared `Diner*` widgets from `lib/core/widgets/` and use tokens from `lib/core/theme/`.

## Deliberately pending

Billing is a **price preview**, as requested: $24.99/year or $5.99/month. There are no real purchases, restore flow, or verified premium entitlements yet. Server-authoritative lifetime allowance across accounts/devices remains to be connected; gateway rate limits are separate from the three welcome Smart uses. The integrated onboarding introduces the experience before showing the final offer; plan names, pricing, free labels and quotas are absent from the educational steps. See the exact integration checklist in [DESIGN.md](DESIGN.md#billing-intentionally-unfinished).

## Stack

Flutter / Dart, Riverpod 2.6 with Notifier providers, GoRouter, Drift/SQLite, HTTP AI gateway, flutter_secure_storage, SharedPreferences, image_picker, and share_plus. The original redesign was validated with Flutter 3.41.7 and Dart 3.11.5; `pubspec.lock` records the current resolved dependencies.

The app is private and not yet live. Historical phase documents describe earlier milestones and are not the current design specification.
