import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_jury/config/routes/app_router.dart';
import 'package:food_jury/core/widgets/widgets.dart';
import 'package:food_jury/data/database/app_database.dart';
import 'package:food_jury/data/providers/database_provider.dart';
import 'package:food_jury/features/case_shelf/data/case_shelf_models.dart';
import 'package:food_jury/features/decision/data/models/food_option.dart';
import 'package:food_jury/features/decision/data/models/objective.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';
import 'package:food_jury/features/decision/presentation/new_decision_screen.dart';
import 'package:food_jury/features/lucky/data/decision_case.dart';
import 'package:food_jury/features/home/presentation/home_screen.dart';
import 'support/diner_harness.dart';

Future<void> _flush(WidgetTester tester) async {
  await tester.runAsync(
    () async => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await scrollTo(tester, finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

class _DraftFailureDatabase extends AppDatabase {
  _DraftFailureDatabase() : super.forTesting(NativeDatabase.memory());
  bool failWrites = false;

  @override
  Future<void> saveCaseDraft(CaseDraft draft) async {
    if (failWrites) throw StateError('Simulated unavailable storage');
    await super.saveCaseDraft(draft);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadDesignFonts);

  testWidgets(
    'quick menu enforces two-to-five, permits deselection and preserves selection order',
    (tester) async {
      final app = DinerHarness();
      await app.pump(tester, route: AppRouter.newDecision);
      await _tap(tester, find.byKey(const Key('quick-menu')));
      DinerButton add() =>
          tester.widget(find.byKey(const Key('add-menu-selection')));
      expect(add().onPressed, isNull);
      await _tap(tester, find.byKey(const ValueKey('food-art-tacos')));
      expect(add().onPressed, isNull);
      for (final id in ['pizza', 'burrito', 'quesadilla', 'burger']) {
        await _tap(tester, find.byKey(ValueKey('food-art-$id')));
      }
      expect(add().onPressed, isNotNull);
      expect(
        tester
            .widget<InkWell>(find.byKey(const ValueKey('food-art-nachos')))
            .onTap,
        isNull,
      );
      await _tap(tester, find.byKey(const ValueKey('food-art-burger')));
      expect(
        tester
            .widget<InkWell>(find.byKey(const ValueKey('food-art-nachos')))
            .onTap,
        isNotNull,
      );
      await _tap(tester, find.byKey(const Key('add-menu-selection')));
      await _flush(tester);
      expect(find.byType(NewDecisionScreen), findsOneWidget);
      final options = tester
          .widgetList<DinerFoodImage>(find.byType(DinerFoodImage))
          .map((image) => image.foodName)
          .toList();
      expect(options, ['Tacos', 'Pizza', 'Burrito', 'Quesadilla']);
      expect(
        tester
            .widget<DinerButton>(find.byKey(const Key('submit-case')))
            .onPressed,
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'resume restores an incomplete case and explicitly discarding removes it',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final app = DinerHarness();
      await app.pump(
        tester,
        history: [],
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      await tester.runAsync(
        () => db.saveCaseDraft(
          CaseDraft(
            options: const [
              FoodOption(
                id: 'custom',
                name: 'Mofongo with garlic',
                notes: 'Shared plate',
                illustrationId: 'mofongo',
              ),
            ],
          ),
        ),
      );
      await _flush(tester);
      await _tap(tester, find.byKey(const Key('resume-case')));
      await _flush(tester);
      expect(find.text('Mofongo with garlic'), findsOneWidget);
      expect(find.text('Shared plate'), findsOneWidget);
      expect(
        tester
            .widget<DinerButton>(find.byKey(const Key('submit-case')))
            .onPressed,
        isNull,
      );
      app.router.go(AppRouter.home);
      await _flush(tester);
      await _tap(tester, find.byTooltip('Discard draft'));
      await _tap(tester, find.widgetWithText(DinerButton, 'DISCARD DRAFT'));
      await _flush(tester);
      expect(find.byKey(const Key('resume-case')), findsNothing);
    },
  );

  testWidgets(
    'a saved lineup opens from Home and remains reusable after editing',
    (tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final app = DinerHarness();
      await app.pump(
        tester,
        history: [],
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      await tester.runAsync(
        () => db.saveCaseSet(
          SavedCaseSet(
            id: 'office',
            name: 'Office lunch',
            draft: CaseDraft(
              options: const [pizza, taco],
              objective: Objective.quick,
            ),
          ),
        ),
      );
      await _flush(tester);
      await _tap(tester, find.byKey(const ValueKey('case-set-office')));
      await _flush(tester);
      expect(find.text('Pepperoni pizza'), findsOneWidget);
      expect(
        tester
            .widget<DinerButton>(find.byKey(const Key('submit-case')))
            .onPressed,
        isNotNull,
      );
      await _tap(tester, find.byTooltip('Remove Pepperoni pizza'));
      await _flush(tester);
      final shelf = await tester.runAsync(() => db.watchCaseShelf().first);
      expect(shelf!.draft!.options, [taco]);
      expect(shelf.sets.single.draft.options, [pizza, taco]);
    },
  );

  testWidgets(
    'history searches original contenders and reopens filtered Lucky evidence',
    (tester) async {
      final random = sampleVerdict.copyWith(
        id: 'lucky',
        rankings: const [],
        contenders: const [pizza, taco],
        winner: pizza,
        random: const RandomRuling(
          method: RandomMethod.wheel,
          quoteId: 'test',
          quote: 'One fair draw.',
          locale: 'en',
          catalogVersion: 1,
        ),
      );
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.history,
        history: [sampleVerdict, random],
      );
      await _tap(tester, find.byKey(const ValueKey('history-filter-lucky')));
      await tester.enterText(
        find.byKey(const Key('history-search')),
        'extra lime',
      );
      await tester.pumpAndSettle();
      expect(find.text('Pepperoni pizza'), findsOneWidget);
      expect(find.text('Tacos al pastor'), findsNothing);
      await _tap(tester, find.byTooltip('Case actions'));
      await _tap(tester, find.text('Reopen case'));
      await _flush(tester);
      expect(find.byType(NewDecisionScreen), findsOneWidget);
      expect(find.text('Pepperoni pizza'), findsOneWidget);
      expect(find.text('Tacos al pastor'), findsOneWidget);
      expect(find.text('Extra lime, please.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'failed final removal remains recoverable and header back protects unsaved changes',
    (tester) async {
      final db = _DraftFailureDatabase();
      addTearDown(db.close);
      final draft = CaseDraft(options: const [pizza]);
      final app = DinerHarness();
      await app.pump(
        tester,
        route: AppRouter.newDecision,
        extra: draft,
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      await _flush(tester);
      db.failWrites = true;
      await _tap(tester, find.byTooltip('Remove Pepperoni pizza'));
      await _flush(tester);
      final retry = find.widgetWithText(TextButton, 'Retry');
      expect(retry, findsOneWidget);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('LATEST CHANGES ARE NOT SAVED'), findsOneWidget);
      await _tap(tester, find.widgetWithText(DinerButton, 'KEEP EDITING'));
      expect(find.byType(NewDecisionScreen), findsOneWidget);
      db.failWrites = false;
      await _tap(tester, retry);
      await _flush(tester);
      expect(
        (await tester.runAsync(() => db.watchCaseShelf().first))!.draft,
        isNull,
      );
      await tester.tap(find.byTooltip('Back'));
      await _flush(tester);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'system back after failed save can explicitly leave with the last durable draft',
    (tester) async {
      final db = _DraftFailureDatabase();
      addTearDown(db.close);
      final draft = CaseDraft(options: const [pizza, taco]);
      final app = DinerHarness();
      await app.pump(
        tester,
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      app.router.push(AppRouter.newDecision, extra: draft);
      await _flush(tester);
      db.failWrites = true;
      await _tap(tester, find.byTooltip('Remove Pepperoni pizza'));
      await _flush(tester);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('LATEST CHANGES ARE NOT SAVED'), findsOneWidget);
      await _tap(tester, find.widgetWithText(DinerButton, 'LEAVE ANYWAY'));
      await _flush(tester);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(
        (await tester.runAsync(() => db.watchCaseShelf().first))!.draft,
        draft,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('naming a lineup saves once and closes the modal', (
    tester,
  ) async {
    final app = DinerHarness();
    await app.pump(
      tester,
      route: AppRouter.newDecision,
      extra: CaseDraft(options: const [pizza, taco]),
    );
    await _flush(tester);
    await _tap(tester, find.byKey(const Key('name-case-set')));
    await tester.enterText(
      find.byKey(const Key('case-set-name')),
      'Late lunch',
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.byKey(const Key('save-case-set')));
    await _flush(tester);
    expect(find.byKey(const Key('case-set-name')), findsNothing);
    final db = app.container.read(databaseProvider);
    final shelf = await tester.runAsync(() => db.watchCaseShelf().first);
    expect(shelf!.sets.single.name, 'Late lunch');
    expect(shelf.sets.single.draft.options, [pizza, taco]);
    expect(shelf.draft!.options, [pizza, taco]);
    expect(tester.takeException(), isNull);
  });
}
