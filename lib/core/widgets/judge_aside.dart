import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/decision/data/models/verdict.dart';
import '../providers/judge_tone_provider.dart';
import '../theme/theme.dart';
import 'diner_motion.dart';
import 'judge_bite.dart';

/// Actual interaction moments, separate from a saved verdict's immutable quote.
enum JudgeMoment {
  welcome,
  firstContender,
  photoAdded,
  caseReady,
  objection,
  saved,
  repeatWinner,
  reopen,
  share,
  jury,
  choiceConfirmed,
}

/// Session-local banter never writes demo activity into case history.
final judgeBanterProvider = FutureProvider<JudgeBanter>((ref) async {
  final data = await rootBundle.loadString('assets/data/judge_moments.json');
  return JudgeBanter.fromJson(jsonDecode(data) as Map<String, dynamic>);
});

/// Shuffles contextual lines without immediate repeats, independently per tone.
class JudgeBanter {
  JudgeBanter.fromJson(Map<String, dynamic> json, {Random? random})
    : _entries = (json['entries'] as List).cast<Map<String, dynamic>>(),
      _random = random ?? Random();

  final List<Map<String, dynamic>> _entries;
  final Random _random;
  final Map<String, List<Map<String, dynamic>>> _bags = {};
  final Map<String, String> _last = {};

  /// Chooses only copy appropriate to the actual event and requested language.
  String next(JudgeMoment moment, JudgeTone tone, String language) {
    final locale = language == 'es' ? 'es' : 'en';
    final key = '${moment.name}.${tone.name}.$locale';
    var bag = _bags[key];
    if (bag == null || bag.isEmpty) {
      bag =
          _entries
              .where(
                (e) =>
                    e['moment'] == moment.name &&
                    (e['tone'] == 'any' || e['tone'] == tone.name),
              )
              .toList()
            ..shuffle(_random);
      if (bag.isEmpty) return '';
      if (bag.length > 1 && bag.last['id'] == _last[key]) {
        final last = bag.removeLast();
        bag.insert(0, last);
      }
      _bags[key] = bag;
    }
    final entry = bag.removeLast();
    _last[key] = entry['id'] as String;
    return (entry['text'] as Map)[locale] as String;
  }
}

/// A small, finite reaction that keeps the same saying across unrelated rebuilds.
class JudgeAside extends ConsumerStatefulWidget {
  const JudgeAside({
    required this.moment,
    this.eventId,
    this.compact = false,
    super.key,
  });

  final JudgeMoment moment;
  final String? eventId;
  final bool compact;

  @override
  ConsumerState<JudgeAside> createState() => _JudgeAsideState();
}

class _JudgeAsideState extends ConsumerState<JudgeAside> {
  String? _identity;
  String _line = '';

  @override
  Widget build(BuildContext context) {
    final tone = ref.watch(judgeToneProvider);
    final banter = ref.watch(judgeBanterProvider).asData?.value;
    final locale = Localizations.localeOf(context).languageCode;
    final identity = '${widget.moment.name}.${widget.eventId}.$tone.$locale';
    if (banter != null && identity != _identity) {
      _identity = identity;
      _line = banter.next(widget.moment, tone, locale);
    }
    if (_line.isEmpty) return const SizedBox.shrink();
    final largeText =
        MediaQuery.textScalerOf(context).scale(1) >=
        DinerTokens.largeTextBreakpoint;
    final pose = switch (widget.moment) {
      JudgeMoment.photoAdded => JudgeBitePose.inspecting,
      JudgeMoment.objection ||
      JudgeMoment.repeatWinner => JudgeBitePose.objection,
      JudgeMoment.saved => JudgeBitePose.filing,
      JudgeMoment.share || JudgeMoment.jury => JudgeBitePose.whispering,
      JudgeMoment.caseReady ||
      JudgeMoment.choiceConfirmed => JudgeBitePose.bell,
      JudgeMoment.reopen => JudgeBitePose.inspecting,
      JudgeMoment.firstContender => JudgeBitePose.thinking,
      JudgeMoment.welcome => JudgeBitePose.waving,
    };
    return DinerEntrance(
      key: ValueKey(identity),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!largeText) ...[
            ExcludeSemantics(
              child: JudgeBite(
                pose: pose,
                dimension: widget.compact
                    ? DinerTokens.touchTarget
                    : DinerTokens.historyThumbnail,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
          ],
          Expanded(
            child: Text(
              _line,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
