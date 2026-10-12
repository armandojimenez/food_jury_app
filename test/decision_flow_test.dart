import 'dart:async';
import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/config/routes/app_router.dart';
import 'package:food_jury/core/providers/ai_service_provider.dart';
import 'package:food_jury/core/providers/image_picker_provider.dart';
import 'package:food_jury/core/providers/judge_tone_provider.dart';
import 'package:food_jury/core/providers/mock_ai_provider.dart';
import 'package:food_jury/core/services/ai_service.dart';
import 'package:food_jury/core/services/image_picker_service.dart';
import 'package:food_jury/core/widgets/widgets.dart';
import 'package:food_jury/data/database/app_database.dart';
import 'package:food_jury/data/providers/database_provider.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/objective.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';
import 'package:food_jury/features/decision/presentation/new_decision_screen.dart';
import 'package:food_jury/features/lucky/presentation/method_picker_screen.dart';
import 'package:food_jury/features/decision/presentation/verdict_screen.dart';
import 'support/diner_harness.dart';

final photoBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jvXQAAAAASUVORK5CYII=',
);

class ControlledAi implements AiService {
  final result = Completer<Verdict>();
  List<FoodOption>? options;
  Objective? objective;
  JudgeTone? tone;
  Locale? locale;
  int calls = 0;
  @override
  Future<Verdict> generateVerdict({
    required List<FoodOption> options,
    required Objective objective,
    required JudgeTone tone,
    required Locale locale,
  }) {
    this.options = options;
    this.objective = objective;
    this.tone = tone;
    this.locale = locale;
    calls++;
    return result.future;
  }

  Verdict get verdict => sampleVerdict.copyWith(
    winner: options!.first,
    rankings: options,
    objective: objective,
    judgeTone: tone,
  );
}

class ControlledDatabase extends AppDatabase {
  ControlledDatabase() : super.forTesting(NativeDatabase.memory());
  final saveGate = Completer<void>();
  Verdict? attempted;
  bool fail = false;
  @override
  Future<void> saveVerdict(Verdict verdict) async {
    attempted = verdict;
    await saveGate.future;
    if (fail) throw StateError('Test storage failure');
    await super.saveVerdict(verdict);
  }
}

class TestPhotoPicker extends ImagePickerService {
  int cameraCalls = 0;
  int galleryCalls = 0;
  @override
  Future<ImagePickResult> pickFromCamera() async {
    cameraCalls++;
    return ImagePickResult.success(photoBytes);
  }

  @override
  Future<ImagePickResult> pickFromGallery() async {
    galleryCalls++;
    return ImagePickResult.success(photoBytes);
  }
}

Future<void> drain(WidgetTester tester) async {
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
  });
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> addOption(
  WidgetTester tester,
  String name, {
  bool photo = false,
  bool spanish = false,
  String? notes,
}) async {
  final add = find.byKey(const Key('add-option'));
  await scrollTo(tester, add);
  await tester.tap(add);
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('option-name')), name);
  if (notes != null) {
    await tester.enterText(find.byKey(const Key('option-notes')), notes);
  }
  if (photo) {
    await scrollTo(tester, find.byType(FoodImagePicker));
    await tester.tap(find.byType(FoodImagePicker));
    await tester.pumpAndSettle();
    final gallery = find.widgetWithText(
      DinerButton,
      spanish ? 'ELEGIR DE GALERÍA' : 'CHOOSE FROM GALLERY',
    );
    await scrollTo(tester, gallery);
    await tester.tap(gallery);
    await drain(tester);
  }
  final save = find.byKey(const Key('save-option'));
  await scrollTo(tester, save);
  await tester.tap(save);
  await tester.pumpAndSettle();
}

Future<void> chooseFunAndSubmit(
  WidgetTester tester, {
  bool spanish = false,
}) async {
  final choice = find.byWidgetPredicate(
    (w) => w is DinerChoice && w.label == (spanish ? 'Diversión' : 'Fun'),
  );
  await scrollTo(tester, choice);
  await tester.tap(choice);
  await tester.pump();
  final submit = find.byKey(const Key('submit-case'));
  await scrollTo(tester, submit);
  await tester.tap(submit);
  await drain(tester);
  await scrollTo(tester, find.byKey(const Key('ask-ai')));
  await tester.tap(find.byKey(const Key('ask-ai')));
  await drain(tester);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadDesignFonts);

  testWidgets(
    '2–5 options, explicit objective, edit and remove remain usable',
    (tester) async {
      final app = DinerHarness();
      await app.pump(tester, route: AppRouter.newDecision);
      DinerButton submit() =>
          tester.widget(find.byKey(const Key('submit-case')));
      expect(submit().onPressed, isNull);
      await addOption(tester, 'Pizza');
      expect(submit().onPressed, isNull);
      await addOption(tester, 'Tacos');
      expect(submit().onPressed, isNull);
      await scrollTo(tester, find.text("WHAT’S ON THE MENU?"));
      await app.screenshot(tester, 'case-populated-phone');
      final edit = find.byTooltip('Edit option').first;
      await scrollTo(tester, edit);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('option-name')),
        'Veggie pizza',
      );
      await scrollTo(tester, find.byKey(const Key('save-option')));
      await tester.tap(find.byKey(const Key('save-option')));
      await tester.pumpAndSettle();
      expect(find.text('Veggie pizza'), findsOneWidget);
      for (final name in ['Salad', 'Sushi', 'Noodles']) {
        await addOption(tester, name);
      }
      expect(find.byKey(const Key('add-option')), findsNothing);
      final remove = find.byTooltip('Remove Veggie pizza');
      await scrollTo(tester, remove);
      await tester.tap(remove);
      await tester.pumpAndSettle();
      expect(find.text('Veggie pizza'), findsNothing);
      expect(find.byKey(const Key('add-option')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'first case uses saved tone and photo bytes; navigation waits for durable save',
    (tester) async {
      final ai = ControlledAi();
      final db = ControlledDatabase();
      addTearDown(db.close);
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.newDecision,
        preferences: {'judge_tone': 'chill', 'use_mock_ai': true},
        overrides: [
          aiServiceProvider.overrideWithValue(ai),
          databaseProvider.overrideWithValue(db),
          imagePickerServiceProvider.overrideWithValue(TestPhotoPicker()),
        ],
      );
      await addOption(tester, 'Pizza', photo: true);
      await addOption(tester, 'Tacos');
      await chooseFunAndSubmit(tester);
      expect(ai.calls, 1);
      expect(ai.tone, JudgeTone.chill);
      expect(ai.locale, const Locale('en'));
      expect(ai.options!.first.imageBytes, orderedEquals(photoBytes));
      expect(ai.objective, Objective.fun);
      expect(find.byType(DinerDeliberation), findsOneWidget);
      final boundary = tester.widget<DinerBusyBoundary>(
        find.byType(DinerBusyBoundary),
      );
      expect(boundary.busy, isTrue);
      ai.result.complete(ai.verdict);
      await drain(tester);
      expect(db.attempted, isNotNull);
      expect(find.byType(VerdictScreen), findsNothing);
      db.saveGate.complete();
      await drain(tester);
      await tester.pumpAndSettle();
      expect(find.byType(VerdictScreen), findsOneWidget);
      final saved = await tester.runAsync(() => db.getAllVerdicts());
      expect(saved!.single.winner.imageBytes, orderedEquals(photoBytes));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'camera, change, edit and removal keep photo state attached to the option',
    (tester) async {
      final picker = TestPhotoPicker();
      final ai = ControlledAi();
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.newDecision,
        overrides: [
          imagePickerServiceProvider.overrideWithValue(picker),
          aiServiceProvider.overrideWithValue(ai),
        ],
      );
      await addOption(tester, 'Pizza', photo: true, notes: 'Extra cheese');
      expect(picker.galleryCalls, 1);
      Future<void> edit() async {
        final button = find.byTooltip('Edit option').first;
        await scrollTo(tester, button);
        await tester.tap(button);
        await tester.pumpAndSettle();
      }

      Future<void> save() async {
        final button = find.byKey(const Key('save-option'));
        await scrollTo(tester, button);
        await tester.tap(button);
        await tester.pumpAndSettle();
      }

      Future<void> source(String label) async {
        await scrollTo(tester, find.byType(FoodImagePicker));
        await tester.tap(find.byType(FoodImagePicker));
        await tester.pumpAndSettle();
        final button = find.widgetWithText(DinerButton, label);
        await scrollTo(tester, button);
        await tester.tap(button);
        await drain(tester);
      }

      await edit();
      expect(
        tester.widget<FoodImagePicker>(find.byType(FoodImagePicker)).imageBytes,
        orderedEquals(photoBytes),
      );
      expect(
        tester
            .widget<TextFormField>(find.byKey(const Key('option-notes')))
            .controller!
            .text,
        'Extra cheese',
      );
      await source('TAKE PHOTO');
      expect(picker.cameraCalls, 1);
      await save();
      await edit();
      expect(
        tester.widget<FoodImagePicker>(find.byType(FoodImagePicker)).imageBytes,
        orderedEquals(photoBytes),
      );
      await source('REMOVE PHOTO');
      expect(
        tester.widget<FoodImagePicker>(find.byType(FoodImagePicker)).imageBytes,
        isNull,
      );
      await save();
      await addOption(tester, 'Tacos');
      await chooseFunAndSubmit(tester);
      expect(ai.options!.first.imageBytes, isNull);
      expect(ai.options!.first.notes, 'Extra cheese');
      ai.result.completeError(const AiServiceException('End test'));
      await drain(tester);
      expect(tester.takeException(), isNull);
    },
  );

  for (final config in [
    (name: 'tablet', size: const Size(834, 1194), scale: 1.0, locale: 'en'),
    (
      name: 'spanish-large',
      size: const Size(320, 568),
      scale: 2.0,
      locale: 'es',
    ),
  ]) {
    testWidgets('populated case and editor stay usable on ${config.name}', (
      tester,
    ) async {
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.newDecision,
        size: config.size,
        textScale: config.scale,
        locale: config.locale,
      );
      await addOption(
        tester,
        'Pizza con queso y vegetales de la casa',
        notes: 'Sin cebolla. Extra queso.',
      );
      await addOption(tester, 'Tacos al pastor con piña');
      await scrollTo(
        tester,
        find
            .byTooltip(config.locale == 'es' ? 'Editar opción' : 'Edit option')
            .first,
      );
      await app.screenshot(tester, 'case-populated-${config.name}');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'AI failure keeps the case and unlocks retry without popping the screen',
    (tester) async {
      final ai = ControlledAi();
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.newDecision,
        overrides: [aiServiceProvider.overrideWithValue(ai)],
      );
      await addOption(tester, 'Pizza');
      await addOption(tester, 'Salad');
      await chooseFunAndSubmit(tester);
      ai.result.completeError(const AiServiceException('Offline'));
      await drain(tester);
      expect(find.byType(DinerDeliberation), findsNothing);
      expect(find.byType(MethodPickerScreen), findsOneWidget);
      final edit = find.widgetWithText(DinerButton, 'EDIT THIS CASE');
      await scrollTo(tester, edit);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      expect(find.byType(NewDecisionScreen), findsOneWidget);
      expect(find.text('Pizza'), findsOneWidget);
      expect(
        tester
            .widget<DinerButton>(find.byKey(const Key('submit-case')))
            .onPressed,
        isNotNull,
      );
    },
  );

  testWidgets('storage failure never opens an unsaved verdict', (tester) async {
    final ai = ControlledAi();
    final db = ControlledDatabase()..fail = true;
    addTearDown(db.close);
    final app = DinerHarness();
    await app.pump(
      tester,
      route: AppRouter.newDecision,
      overrides: [
        aiServiceProvider.overrideWithValue(ai),
        databaseProvider.overrideWithValue(db),
      ],
    );
    await addOption(tester, 'Pizza');
    await addOption(tester, 'Salad');
    await chooseFunAndSubmit(tester);
    ai.result.complete(ai.verdict);
    await drain(tester);
    db.saveGate.complete();
    await drain(tester);
    expect(find.byType(VerdictScreen), findsNothing);
    expect(find.byType(DinerDeliberation), findsNothing);
    expect(
      tester.widget<DinerButton>(find.byKey(const Key('ask-ai'))).onPressed,
      isNotNull,
    );
  });

  testWidgets(
    'Spanish case forwards locale and preserves independent objective selection',
    (tester) async {
      final ai = ControlledAi();
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.newDecision,
        locale: 'es',
        overrides: [aiServiceProvider.overrideWithValue(ai)],
      );
      await addOption(tester, 'Pizza');
      await addOption(tester, 'Ensalada');
      await chooseFunAndSubmit(tester, spanish: true);
      expect(ai.locale, const Locale('es'));
      ai.result.completeError(const AiServiceException('End test'));
      await drain(tester);
    },
  );

  testWidgets('persisted mock choice is ready on direct case startup', (
    tester,
  ) async {
    final app = DinerHarness();
    await app.pump(
      tester,
      route: AppRouter.newDecision,
      preferences: {'judge_tone': 'sassy', 'use_mock_ai': true},
    );
    await tester.runAsync(() async {
      await app.container.read(judgeToneProvider.notifier).ready;
      await app.container.read(mockAiNotifierProvider.notifier).ready;
    });
    expect(app.container.read(judgeToneProvider), JudgeTone.sassy);
    expect(app.container.read(mockAiNotifierProvider), isTrue);
  });

  testWidgets(
    'new verdict reveals, can replay, and safely disposes mid-animation',
    (tester) async {
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.verdict,
        extra: sampleVerdict,
        reducedMotion: false,
      );
      expect(
        tester.widget<DinerBusyBoundary>(find.byType(DinerBusyBoundary)).busy,
        isTrue,
      );
      await app.screenshot(tester, 'verdict-reveal-phone');
      await tester.pump(const Duration(seconds: 3));
      await tester.pump();
      expect(
        tester.widget<DinerBusyBoundary>(find.byType(DinerBusyBoundary)).busy,
        isFalse,
      );
      final replay = find.text('Replay the reveal');
      await scrollTo(tester, replay);
      await tester.tap(replay);
      await tester.pump();
      expect(
        tester.widget<DinerBusyBoundary>(find.byType(DinerBusyBoundary)).busy,
        isTrue,
      );
      app.router.go(AppRouter.home);
      await tester.pump(const Duration(seconds: 3));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'enabling reduced motion during the reveal finishes it and stops all tickers',
    (tester) async {
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.verdict,
        extra: sampleVerdict,
        reducedMotion: false,
      );
      expect(
        tester.widget<DinerBusyBoundary>(find.byType(DinerBusyBoundary)).busy,
        isTrue,
      );
      app.motionDisabled.value = true;
      await tester.pump();
      await tester.pump();
      expect(
        tester.widget<DinerBusyBoundary>(find.byType(DinerBusyBoundary)).busy,
        isFalse,
      );
      expect(tester.binding.transientCallbackCount, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'history and reduced motion open immediately without a reveal curtain',
    (tester) async {
      final app = DinerHarness();
      await app.pump(tester, route: AppRouter.verdict, extra: sampleVerdict);
      expect(
        tester.widget<DinerBusyBoundary>(find.byType(DinerBusyBoundary)).busy,
        isFalse,
      );
      expect(find.text('Replay the reveal'), findsNothing);
      expect(tester.binding.transientCallbackCount, 0);
    },
  );
}
