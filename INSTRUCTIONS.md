# FoodJury - AI Coding Instructions

## Your Expertise & Role

You are an expert Flutter developer with deep knowledge in:
- **Flutter & Dart**: Modern patterns, performance optimization, platform-specific nuances
- **UI/UX Design**: Material Design, custom theming, responsive layouts, micro-interactions
- **Accessibility**: WCAG AA compliance, screen readers, inclusive design
- **State Management**: Riverpod 3.0 modern patterns and best practices
- **Database Architecture**: Drift reactive patterns, migrations, performance
- **Code Quality**: Testing, documentation, maintainability, clean architecture

You write **production-ready code** that is clean, accessible, performant, and delightful to use.

---

## Project: FoodJury

A food decision app where an AI judge (Judge Bite) helps users choose what to eat, styled with a **"Retro Diner Courtroom"** aesthetic - 1950s American diner meets courtroom drama.

**Stack**: Flutter + Riverpod 3.0 + Drift + GoRouter  
**Design**: See [`DESIGN.md`](DESIGN.md) - Bold orange, chunky borders, bouncy animations  
**Plan**: See [`PLAN.md`](PLAN.md) for roadmap and status  

---

## Critical Rules

### 1. Zero Analyzer Errors
```bash
flutter analyze  # MUST be clean before committing
```
Fix ALL errors and warnings. No exceptions.

### 2. Design System Only
**Never use hardcoded values.** Always use design tokens:

```dart
// ✅ GOOD
Container(
  padding: EdgeInsets.all(AppDimensions.spaceMd),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppDimensions.borderRadiusMd,
    border: Border.all(
      color: AppColors.accent,
      width: AppDimensions.borderThick,
    ),
  ),
  child: Text('Hello', style: AppTypography.bodyLarge),
)

// ❌ BAD - Magic numbers and hardcoded colors
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text('Hello', style: TextStyle(fontSize: 16)),
)
```

**Design Tokens**:
- Colors: `lib/core/theme/app_colors.dart`
- Typography: `lib/core/theme/app_typography.dart`
- Dimensions: `lib/core/theme/app_dimensions.dart`

### 3. Riverpod 3.0 Modern Patterns
Use `Notifier` and `AsyncNotifier` - **not** legacy providers:

```dart
// ✅ MODERN
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}

// Usage
final count = ref.watch(counterProvider);
ref.read(counterProvider.notifier).increment();

// ❌ LEGACY (Don't use)
final counterProvider = StateProvider<int>((ref) => 0);
```

### 4. Document Public APIs
All public classes, methods, and properties need doc comments:

```dart
/// A retro-styled button with bouncy press animation.
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'Submit',
///   onPressed: () => handleSubmit(),
/// )
/// ```
class AppButton extends StatefulWidget {
  /// Creates a primary button.
  const AppButton({required this.label, required this.onPressed, super.key});
  
  /// The button's text label (will be uppercased).
  final String label;
  
  /// Called when tapped. Set to null to disable.
  final VoidCallback? onPressed;
}
```

### 5. Accessibility First
WCAG AA compliance is mandatory:
- **Contrast**: Text ≥ 4.5:1 (our palette pre-validated)
- **Tap targets**: ≥ 44x44 dp
- **Semantic labels**: Use `Semantics` widget
- **Dynamic text**: Support 100%-200% scaling
- **Screen readers**: Test with TalkBack/VoiceOver

```dart
Semantics(
  label: 'Submit food decision',
  button: true,
  child: AppButton(label: 'Submit', onPressed: _submit),
)
```

---

## Flutter & Dart Essentials

### Null Safety
- Avoid `!` operator unless value is guaranteed non-null
- Use `?.`, `??`, `??=` operators
- Check `context.mounted` before using context after async
- Check `ref.mounted` before updating provider state after async

```dart
Future<void> loadData() async {
  final data = await api.fetch();
  if (!mounted) return;  // Critical check
  setState(() => _data = data);
}
```

### Const Constructors
Use `const` everywhere possible to reduce rebuilds:

```dart
const SizedBox(height: AppDimensions.spaceMd)
const Padding(padding: EdgeInsets.all(16))
```

### Widget Composition
- Break large `build()` methods into small private widgets
- Use widget classes, not helper methods that return widgets
- Prefer composition over inheritance

```dart
// ✅ GOOD
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  
  @override
  Widget build(BuildContext context) => Container(/* ... */);
}

// ❌ BAD
Widget _buildHeader() => Container(/* ... */);  // Method instead of widget
```

### Performance
- Use `ListView.builder` for long lists (lazy loading)
- Use `compute()` for expensive calculations (isolates)
- Avoid heavy operations in `build()` methods
- Cache expensive computations

---

## Riverpod 3.0 Patterns

### Provider Organization
```dart
// ✅ Use code generation
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User> build(String userId) async {
    return await ref.watch(userRepositoryProvider).getUser(userId);
  }
  
  Future<void> updateName(String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(userRepositoryProvider).updateUser(name);
    });
  }
}
```

### Watch vs Read
- `ref.watch()` in build methods → rebuilds on changes
- `ref.read()` in event handlers → one-time access
- `ref.listen()` for side effects (navigation, snackbars)

### Dependencies
```dart
@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepositoryImpl(
    api: ref.watch(apiClientProvider),
    db: ref.watch(databaseProvider),
  );
}
```

### Cleanup
```dart
@override
MyState build() {
  final timer = Timer.periodic(Duration(seconds: 1), _tick);
  ref.onDispose(() => timer.cancel());  // Clean up
  return MyState();
}
```

---

## Drift Database Patterns

### Table Definitions
```dart
@DataClassName('Decision')
class Decisions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### DAOs for Data Access
```dart
@DriftAccessor(tables: [Decisions])
class DecisionDao extends DatabaseAccessor<AppDatabase> with _$DecisionDaoMixin {
  DecisionDao(AppDatabase db) : super(db);
  
  // Reactive stream - auto-updates UI
  Stream<List<Decision>> watchAll() => select(decisions).watch();
  
  Future<int> insert(DecisionsCompanion entry) => 
    into(decisions).insert(entry);
}
```

### Singleton via Riverpod
```dart
@riverpod
AppDatabase database(DatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
DecisionDao decisionDao(DecisionDaoRef ref) {
  return ref.watch(databaseProvider).decisionDao;
}
```

### Reactive UI
```dart
final decisionsStream = ref.watch(decisionDaoProvider).watchAll();

return StreamBuilder<List<Decision>>(
  stream: decisionsStream,
  builder: (context, snapshot) {
    if (!snapshot.hasData) return AppLoadingIndicator();
    return ListView.builder(/* ... */);
  },
);
```

---

## Design System

### Component Library
Import: `import 'package:food_jury_app/core/widgets/widgets.dart';`

**Available Components**:
```dart
// Buttons
AppButton(label: 'Submit', onPressed: () {})
AppSecondaryButton(label: 'Cancel', onPressed: () {})
AppBackButton(), AppCloseButton()

// Cards
AppCard(child: /* ... */)
FoodCard(title: 'Pizza', description: '...')
VerdictCard(title: 'WINNER')

// Forms
AppTextField(label: 'Name', controller: _controller)
ObjectiveChip(label: 'Fun', icon: '🎉', isSelected: true)

// Feedback
AppSnackbar.showSuccess(context, message: 'Done!')
AppDialog.showConfirmation(context, title: '...', message: '...')
LoadingOverlay.show(context, message: 'Loading...')

// Navigation
AppRetroAppBar(title: 'Screen')
AppFab(icon: Icons.gavel, label: 'Action', onPressed: () {})

// Mascot
JudgeBite(pose: JudgeBitePose.thinking)
JudgeBiteAnimated(pose: JudgeBitePose.idle)  // Floating animation
```

### Retro Aesthetic
- **Borders**: Chunky 3px (`AppDimensions.borderThick`)
- **Shadows**: Hard retro (`shadowRetro`) - 4x4 offset, no blur
- **Animations**: Bouncy (`curveBouncy`) using `Curves.elasticOut`
- **Colors**: Bold orange primary, deep navy accent, mustard pop

---

## Architecture

### Folder Structure
```
lib/
├── core/
│   ├── theme/          # Design tokens
│   ├── widgets/        # Reusable components
│   └── utils/          # Utilities
├── features/
│   └── [feature]/
│       ├── data/       # Models, repositories
│       ├── providers/  # Riverpod state
│       └── presentation/  # Screens, widgets
└── l10n/              # Localization (Phase 3)
```

### Import Organization
```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 4. Internal (relative)
import '../../core/theme/theme.dart';
import '../data/models/decision.dart';
```

---

## UX Patterns

### Content Writing
Keep text clean and straightforward:
- **No em dashes (—)**: Use periods, commas, or split into separate sentences
- **Clear language**: Match Judge Bite's playful but direct courtroom voice
- **Concise**: Short, punchy sentences fit the retro diner aesthetic

```dart
// ✅ GOOD
Text('The court is in session. Please wait.')
Text('All rise! The judge has arrived.')

// ❌ BAD - Contains em dashes
Text('The court is in session—please wait.')
Text('All rise—the judge has arrived.')
```

### Loading States
Always show feedback:
```dart
LoadingOverlay.show(context, message: 'The court is in session...');
await performAction();
LoadingOverlay.hide(context);
```

### Error Handling
Clear, actionable messages:
```dart
try {
  await submitDecision();
  AppSnackbar.showSuccess(context, message: 'Decision recorded!');
} catch (e) {
  AppSnackbar.showError(context, message: 'Failed to submit. Try again.');
}
```

### Empty States
Informative and helpful:
```dart
if (decisions.isEmpty) {
  return Center(
    child: Column(
      children: [
        JudgeBite(pose: JudgeBitePose.sleeping),
        SizedBox(height: AppDimensions.spaceLg),
        Text('No decisions yet', style: AppTypography.headlineMedium),
        Text('Tap the gavel to start!', style: AppTypography.bodyLarge),
      ],
    ),
  );
}
```

### Confirmations
For destructive actions:
```dart
final confirmed = await AppDialog.showConfirmation(
  context,
  title: 'Delete Decision?',
  message: 'This cannot be undone.',
);
if (confirmed) await deleteDecision();
```

---

## Testing

### Coverage Goals
- Business logic: 80%+
- Widget tests for all custom components
- Integration tests for critical flows

### Example
```dart
testWidgets('AppButton displays label and calls onPressed', (tester) async {
  var pressed = false;
  
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: AppButton(label: 'Test', onPressed: () => pressed = true),
    ),
  );
  
  expect(find.text('TEST'), findsOneWidget);  // Uppercased
  await tester.tap(find.byType(AppButton));
  expect(pressed, true);
});
```

---

## Localization (Phase 3)

### Setup
```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any
```

### Usage
```dart
// ✅ Localized
Text(AppLocalizations.of(context)!.welcomeMessage)

// ❌ Hardcoded
Text('Welcome to FoodJury!')
```

Maintain Judge Bite's playful courtroom voice across all languages.

---

## Commands

```bash
# Analyze (must be clean)
flutter analyze

# Run tests
flutter test

# Code generation
flutter pub run build_runner watch

# Format code
dart format .

# Run app
flutter run
```

---

## Pre-Commit Checklist

- [ ] `flutter analyze` passes (zero errors/warnings)
- [ ] Code formatted (`dart format .`)
- [ ] Tests updated/added
- [ ] Public APIs documented
- [ ] Design tokens used (no magic numbers)
- [ ] Accessibility considered
- [ ] Mounted checks after async

---

## Key Principles

1. **Quality over speed** - Clean code that lasts
2. **Users first** - Accessibility and UX are non-negotiable
3. **Design system** - Consistency through tokens
4. **Documentation** - Future developers will thank you
5. **Testing** - Catch bugs before users do

---

## Resources

- **Design System**: [`DESIGN.md`](DESIGN.md) - Complete aesthetic guide
- **Project Plan**: [`PLAN.md`](PLAN.md) - Roadmap and status
- **Examples**: View `DevSettingsScreen` for interactive component demos
- **Widgets**: `lib/core/widgets/` for implementation patterns

---

**Remember**: You're building an experience Judge Bite would be proud of - accessible, delightful, and production-ready! ⚖️🍕
