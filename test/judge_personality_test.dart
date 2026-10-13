import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_jury/core/services/court_feedback.dart';
import 'package:food_jury/core/theme/theme.dart';
import 'package:food_jury/core/widgets/judge_aside.dart';
import 'package:food_jury/core/widgets/diner_components.dart';
import 'package:food_jury/features/decision/data/models/verdict.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<Map<String, dynamic>> catalog() async =>
      jsonDecode(await rootBundle.loadString('assets/data/judge_moments.json'))
          as Map<String, dynamic>;

  test(
    'all moments have bilingual tone-specific copy and no immediate repeats',
    () async {
      final data = await catalog();
      final entries = (data['entries'] as List).cast<Map<String, dynamic>>();
      expect(entries.map((e) => e['id']).toSet().length, entries.length);
      for (final moment in JudgeMoment.values) {
        for (final tone in JudgeTone.values) {
          for (final language in ['en', 'es']) {
            final banter = JudgeBanter.fromJson(data, random: Random(42));
            final eligible = entries.where(
              (e) =>
                  e['moment'] == moment.name &&
                  (e['tone'] == tone.name || e['tone'] == 'any'),
            );
            expect(eligible.length, greaterThan(1));
            final lines = List.generate(
              7,
              (_) => banter.next(moment, tone, language),
            );
            for (var i = 0; i < lines.length; i++) {
              expect(lines[i], isNotEmpty);
              expect(
                eligible.any((e) => e['text'][language] == lines[i]),
                isTrue,
              );
              if (i > 0) expect(lines[i], isNot(lines[i - 1]));
            }
          }
        }
      }
    },
  );

  testWidgets(
    'an aside stays stable across rebuilds and changes for a fresh event',
    (tester) async {
      final data = (await tester.runAsync(catalog))!;
      var event = 'first';
      late StateSetter rebuild;
      // Keep one provider scope and one aside state while rebuilding its parent.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            judgeBanterProvider.overrideWith(
              (ref) async => JudgeBanter.fromJson(data, random: Random(1)),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return MediaQuery(
                  data: const MediaQueryData(disableAnimations: true),
                  child: Scaffold(
                    body: JudgeAside(moment: JudgeMoment.saved, eventId: event),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      String visibleLine() => tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(JudgeAside),
              matching: find.byType(Text),
            ),
          )
          .single
          .data!;
      final first = visibleLine();
      rebuild(() {});
      await tester.pumpAndSettle();
      expect(visibleLine(), first);
      rebuild(() => event = 'next');
      await tester.pumpAndSettle();
      expect(visibleLine(), isNot(first));
    },
  );

  test('feedback choices survive provider recreation', () async {
    final first = ProviderContainer();
    await first.read(courtFeedbackPreferencesProvider.notifier).ready;
    await first.read(courtFeedbackPreferencesProvider.notifier).setSound(true);
    await first
        .read(courtFeedbackPreferencesProvider.notifier)
        .setHaptics(false);
    first.dispose();
    final next = ProviderContainer();
    addTearDown(next.dispose);
    await next.read(courtFeedbackPreferencesProvider.notifier).ready;
    expect(next.read(courtFeedbackPreferencesProvider).sound, isTrue);
    expect(next.read(courtFeedbackPreferencesProvider).haptics, isFalse);
  });

  testWidgets('reduced motion suppresses sound and haptics even when enabled', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'court_sound': true,
      'court_haptics': true,
    });
    final calls = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call.method);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Consumer(
              builder: (context, ref, _) => DinerButton(
                label: 'Reveal',
                onPressed: () =>
                    CourtFeedback.play(context, ref, CourtCue.verdict),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('REVEAL'));
    await tester.pumpAndSettle();
    expect(
      calls.where(
        (c) => c == 'HapticFeedback.vibrate' || c == 'SystemSound.play',
      ),
      isEmpty,
    );
  });
}
