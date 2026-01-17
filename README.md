# FoodJury ⚖️🍕

An AI-powered food decision app with a retro diner courtroom aesthetic. Let Judge Bite help you decide what to eat!

## 🚀 Quick Start for New AI Sessions

**First time working on this project?** Read these in order:

1. **[`INSTRUCTIONS.md`](INSTRUCTIONS.md)** - Coding standards, patterns, your expert persona
2. **[`PLAN.md`](PLAN.md)** - Project status, what's done, what's next
3. **[`DESIGN.md`](DESIGN.md)** - Complete design system reference

## 📊 Current Status

**Phases 1-3**: ✅ Complete!
- ✅ Foundation + UI Systems
- ✅ Localization (English & Spanish)
- ✅ Navigation (GoRouter)
- ✅ Core Screens (Home + New Decision)

**Phase 4**: 👉 Ready to start (AI & Data integration)

See [`PLAN.md`](PLAN.md) for detailed roadmap.

## 💻 Development

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Analyze code (must be clean)
flutter analyze

# Run tests
flutter test

# Code generation
flutter pub run build_runner watch
```

## 🎨 Design System

**"Retro Diner Courtroom"** aesthetic:
- **Colors**: Blazing orange (#FF6B35), Deep navy (#1A1A2E), Mustard yellow (#FFD23F)
- **Typography**: Bangers (display), Nunito (body)
- **Style**: Chunky 3px borders, hard retro shadows, bouncy animations

**All design tokens in**: `lib/core/theme/`  
**All components in**: `lib/core/widgets/`

See [`DESIGN.md`](DESIGN.md) for complete reference.

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── theme/          # Design tokens (colors, typography, dimensions)
│   └── widgets/        # Reusable UI components
├── features/
│   └── [feature]/
│       ├── data/       # Models, repositories
│       ├── providers/  # Riverpod state
│       └── presentation/  # Screens, widgets
└── l10n/              # Localization (Phase 3)
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.27.1+
- **Language**: Dart 3.6.0+
- **State Management**: Riverpod 3.0 (with code generation)
- **Navigation**: GoRouter
- **Database**: Drift (SQLite)
- **AI**: Firebase AI Logic + Gemini 2.5 Flash Lite

## 📚 Documentation

- **[INSTRUCTIONS.md](INSTRUCTIONS.md)** - Complete coding standards (~6,000 words)
- **[PLAN.md](PLAN.md)** - Project roadmap and status
- **[DESIGN.md](DESIGN.md)** - Full design system specification
- **[PHASE_1_SUMMARY.md](PHASE_1_SUMMARY.md)** - Core widgets summary
- **[PHASE_2_SUMMARY.md](PHASE_2_SUMMARY.md)** - UI systems summary

## 🎯 Core Principles

1. **Zero analyzer errors** - `flutter analyze` must always pass
2. **Design system only** - No hardcoded colors, sizes, or styles
3. **Riverpod 3.0** - Modern patterns with code generation
4. **Accessibility first** - WCAG AA compliance
5. **Production quality** - Document, test, optimize

## 🎮 Try It Out

Run the app and tap **"View Design System"** to see interactive demos of all components!

## 📝 What's Next (Phase 4)

1. **AI Integration** - Connect Gemini 2.5 Flash Lite for verdicts
2. **Storage** - Drift database for decision history
3. **Verdict Screen** - Dramatic reveal animation
4. **Advanced Features** - Image upload, sharing, more

See full Phase 4 details in [`PLAN.md`](PLAN.md) and [`PHASE_3_COMPLETE.md`](PHASE_3_COMPLETE.md).

## 🤝 Contributing (AI Guidelines)

Read [`INSTRUCTIONS.md`](INSTRUCTIONS.md) for:
- Expert persona definition
- 5 critical rules
- Flutter & Dart best practices
- Riverpod 3.0 patterns
- Drift database architecture
- Design system integration
- Accessibility requirements
- Testing guidelines

## 📄 License

This project is private and proprietary.

---

**Built with Flutter, Riverpod, and ⚖️ Judge Bite's approval!**
