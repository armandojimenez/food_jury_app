import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/ai_service_provider.dart';
import '../../../core/providers/judge_tone_provider.dart';
import '../../../core/providers/mock_ai_provider.dart';
import '../../../core/services/ai_service.dart';
import '../../../data/providers/database_provider.dart';
import '../../../data/providers/verdict_provider.dart';
import '../../../data/database/app_database.dart';
import '../../decision/data/models/verdict.dart';
import 'decision_case.dart';

/// Store adapter seam. Real, verified entitlements are not connected yet.
/// Test/preview overrides can exercise Plus without pretending to buy it.
final premiumAccessProvider = Provider<bool>((ref) => false);
final aiAllowanceProvider = FutureProvider<int>(
  (ref) => ref.watch(databaseProvider).remainingAiDecisions(),
);

/// A retry keeps the operation ID and any successful generated result.
class AiAttempt {
  AiAttempt(this.caseData, this.locale) : id = const Uuid().v4();
  final DecisionCase caseData;
  final Locale locale;
  final String id;
  Verdict? _generated;
}

final aiCourtProvider = Provider<AiCourt>((ref) => AiCourt(ref));

/// Serializes AI requests and commits the result with its allowance together.
class AiCourt {
  AiCourt(this.ref);
  final Ref ref;
  bool _busy = false;

  Future<Verdict> decide(AiAttempt attempt) async {
    if (_busy) throw StateError('A ruling is already in progress');
    _busy = true;
    try {
      final db = ref.read(databaseProvider);
      final existing = await db.getVerdictById(attempt.id);
      if (existing != null) return existing;
      final premium = ref.read(premiumAccessProvider);
      if (!premium && await db.remainingAiDecisions() == 0) {
        throw AiAllowanceExhausted();
      }
      await ref.read(judgeToneProvider.notifier).ready;
      await ref.read(mockAiNotifierProvider.notifier).ready;
      if (attempt._generated == null) {
        final result = await ref
            .read(aiServiceProvider)
            .generateVerdict(
              options: attempt.caseData.options,
              objective: attempt.caseData.objective,
              tone: ref.read(judgeToneProvider),
              locale: attempt.locale,
            )
            .timeout(const Duration(seconds: 45));
        final ids = attempt.caseData.options.map((o) => o.id).toSet();
        if (result.isRandom ||
            result.reasoning.trim().isEmpty ||
            result.rankings.length != ids.length ||
            result.rankings
                .map((o) => o.id)
                .toSet()
                .difference(ids)
                .isNotEmpty ||
            result.rankings.map((o) => o.id).toSet().length != ids.length ||
            result.rankings.first.id != result.winner.id) {
          throw const AiServiceException('Invalid AI ruling');
        }
        // Keep exact original user evidence; AI controls only ordering and prose.
        final originals = {for (final o in attempt.caseData.options) o.id: o};
        attempt._generated = result
            .copyWith(
              id: attempt.id,
              winner: originals[result.winner.id]!,
              rankings: result.rankings.map((o) => originals[o.id]!).toList(),
              contenders: attempt.caseData.options,
              objective: attempt.caseData.objective,
            )
            .snapshot();
      }
      await db.saveAiVerdict(attempt._generated!, premium: premium);
      ref.invalidate(aiAllowanceProvider);
      ref.invalidate(verdictsProvider);
      ref.invalidate(recentVerdictsProvider);
      return attempt._generated!;
    } finally {
      _busy = false;
    }
  }
}

final luckyCourtProvider = Provider<LuckyCourt>((ref) => LuckyCourt());

/// Cryptographic uniform draw; animation timing never influences the outcome.
class LuckyCourt {
  LuckyCourt({Random? random}) : _random = random ?? Random.secure();
  final Random _random;
  Map<String, dynamic>? _catalog;

  /// Draws once and records the exact quote for replay and history.
  Future<Verdict> draw({
    required DecisionCase caseData,
    required RandomMethod method,
    required JudgeTone tone,
    required Locale locale,
  }) async {
    if (method == RandomMethod.coin && caseData.options.length != 2) {
      throw ArgumentError('The coin needs exactly two contenders');
    }
    final winner = caseData.options[_random.nextInt(caseData.options.length)];
    _catalog ??=
        jsonDecode(
              await rootBundle.loadString('assets/data/judge_sayings.json'),
            )
            as Map<String, dynamic>;
    final language = locale.languageCode == 'es' ? 'es' : 'en';
    final entries = (_catalog!['entries'] as List)
        .cast<Map<String, dynamic>>()
        .where(
          (e) =>
              (e['tone'] == tone.name || e['tone'] == 'any') &&
              (e['methods'] as List).contains(method.name),
        )
        .toList();
    final prefs = await SharedPreferences.getInstance();
    final key =
        'sayings_v${_catalog!['version']}_${tone.name}_${method.name}_$language';
    final eligible = entries.map((e) => e['id'] as String).toSet();
    var bag = (prefs.getStringList(key) ?? [])
        .where(eligible.contains)
        .toList();
    final previous = prefs.getString('${key}_last');
    if (bag.isEmpty) {
      bag = eligible.toList()..shuffle(_random);
      if (bag.length > 1 && bag.last == previous) {
        final first = bag.first;
        bag[0] = bag.last;
        bag[bag.length - 1] = first;
      }
    }
    final id = bag.removeLast();
    await prefs.setStringList(key, bag);
    await prefs.setString('${key}_last', id);
    final entry = entries.firstWhere((e) => e['id'] == id);
    return Verdict(
      id: const Uuid().v4(),
      winner: winner,
      rankings: const [],
      reasoning: '',
      objective: caseData.objective,
      judgeTone: tone,
      createdAt: DateTime.now(),
      contenders: caseData.options,
      random: RandomRuling(
        method: method,
        quoteId: id,
        quote: (entry['text'] as Map)[language] as String,
        locale: language,
        catalogVersion: _catalog!['version'] as int,
      ),
    ).snapshot();
  }
}
