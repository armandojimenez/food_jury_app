import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/providers/judge_tone_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../decision/data/models/food_option.dart';
import '../../decision/data/models/objective.dart';
import '../../food_library/data/food_catalog.dart';
import '../../lucky/data/court_providers.dart';
import '../../lucky/data/decision_case.dart';
import '../../lucky/presentation/lucky_draw_screen.dart';
import '../data/jury_session.dart';

/// Local nominations and private ballots with a Lucky tie-breaker.
class JuryScreen extends ConsumerStatefulWidget {
  /// Creates a new local session, discarded when this route closes.
  const JuryScreen({super.key});

  @override
  ConsumerState<JuryScreen> createState() => _JuryScreenState();
}

class _JuryScreenState extends ConsumerState<JuryScreen> {
  int _participants = 2;
  JurySession? _session;
  bool _handOff = true, _busy = false;
  final _name = TextEditingController();
  String? _artId, _selectedVote, _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickFood() async {
    final art = await context.push<FoodArt>(AppRouter.foodLibrary);
    if (art == null || !mounted) return;
    setState(() {
      _artId = art.id;
      _name.text = art.generic
          ? ''
          : art.label(Localizations.localeOf(context).languageCode);
      _error = null;
    });
  }

  void _nominate() {
    if (_handOff || _session == null || _session!.readyToVote) return;
    try {
      _session!.nominate(
        FoodOption(
          id: const Uuid().v4(),
          name: _name.text.trim(),
          illustrationId: _artId,
        ),
      );
      setState(() {
        _name.clear();
        _artId = null;
        _handOff = true;
        _error = null;
      });
    } on ArgumentError {
      setState(() => _error = context.l10n.jury_distinctDish);
    }
  }

  Future<void> _breakTie() async {
    if (_busy) return;
    setState(() => _busy = true);
    final locale = Localizations.localeOf(context);
    try {
      await ref.read(judgeToneProvider.notifier).ready;
      if (!mounted) return;
      final options = _session!.leaders;
      final verdict = await ref
          .read(luckyCourtProvider)
          .draw(
            caseData: DecisionCase(options: options, objective: Objective.fun),
            method: options.length == 2
                ? RandomMethod.coin
                : RandomMethod.wheel,
            tone: ref.read(judgeToneProvider),
            locale: locale,
          );
      if (mounted) {
        await context.push(
          AppRouter.draw,
          extra: DrawRouteData(verdict: verdict),
        );
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          message: context.l10n.error_genericMessage,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final session = _session;
    final complete = session?.complete ?? false;
    final voting = session?.readyToVote ?? false;
    final juror = session == null
        ? 1
        : voting
        ? session.votesCast + 1
        : session.options.length + 1;
    final choices = session?.options ?? const <FoodOption>[];
    return DinerScaffold(
      // Handoff and result phases always open at the top, never at a ballot's
      // old scroll offset. A selected vote alone keeps the same scroll state.
      key: ValueKey((session == null, complete, voting, _handOff, juror)),
      title: l.jury_title,
      maxWidth: DinerTokens.readingWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!(session != null && !complete && _handOff && voting)) ...[
            Center(
              child: JudgeBite(
                pose: complete
                    ? JudgeBitePose.celebrating
                    : session == null
                    ? JudgeBitePose.bench
                    : _handOff
                    ? JudgeBitePose.whispering
                    : JudgeBitePose.inspecting,
                dimension: DinerTokens.rulingJudge,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
          ],
          if (session == null) ...[
            DinerHeading(l.jury_introTitle),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(l.jury_introBody),
            const SizedBox(height: AppDimensions.spaceMd),
            DinerSection(l.jury_howMany),
            const SizedBox(height: AppDimensions.spaceSm),
            Wrap(
              spacing: AppDimensions.spaceSm,
              runSpacing: AppDimensions.spaceSm,
              children: [
                for (var count = 2; count <= 5; count++)
                  ChoiceChip(
                    key: ValueKey('jury-count-$count'),
                    label: Text('$count'),
                    selected: _participants == count,
                    onSelected: (_) => setState(() => _participants = count),
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            DinerButton(
              key: const Key('jury-start'),
              label: l.jury_start,
              style: DinerButtonStyle.mustard,
              icon: Icons.groups_rounded,
              onPressed: () =>
                  setState(() => _session = JurySession(_participants)),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(
              l.jury_localNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else if (complete) ...[
            DinerHeading(
              session.leaders.length == 1
                  ? l.jury_winner(session.leaders.single.name)
                  : l.jury_tie,
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(l.jury_resultsHint),
            const SizedBox(height: AppDimensions.spaceMd),
            for (final option in choices)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                child: DinerTicket(
                  child:
                      MediaQuery.textScalerOf(context).scale(1) >=
                          DinerTokens.largeTextBreakpoint
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              option.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceSm),
                            Text(l.jury_votes(session.results[option.id]!)),
                          ],
                        )
                      : Row(
                          children: [
                            FoodIllustration(
                              name: option.name,
                              illustrationId: option.illustrationId,
                              size: DinerTokens.thumbnail,
                            ),
                            const SizedBox(width: AppDimensions.spaceSm),
                            Expanded(
                              child: Text(
                                option.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spaceSm),
                            Flexible(
                              child: Text(
                                l.jury_votes(session.results[option.id]!),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            if (session.leaders.length > 1) ...[
              const SizedBox(height: AppDimensions.spaceMd),
              Text(l.jury_tieHint),
              const SizedBox(height: AppDimensions.spaceMd),
              DinerButton(
                key: const Key('jury-tiebreak'),
                label: l.jury_tieBreak,
                loading: _busy,
                style: DinerButtonStyle.mustard,
                onPressed: _busy ? null : _breakTie,
              ),
            ],
            const SizedBox(height: AppDimensions.spaceLg),
            DinerButton(
              label: l.jury_again,
              style: DinerButtonStyle.outline,
              onPressed: _busy
                  ? null
                  : () => setState(() {
                      _session = null;
                      _handOff = true;
                      _selectedVote = null;
                      _error = null;
                    }),
            ),
          ] else if (_handOff) ...[
            DinerHeading(l.jury_passTo(juror)),
            const SizedBox(height: AppDimensions.spaceMd),
            if (voting) ...[
              JudgeAside(
                moment: JudgeMoment.jury,
                eventId: 'ballot-${session.votesCast}',
                compact: true,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
            ],
            DinerTicket(
              dashed: true,
              child: Text(voting ? l.jury_votePrivacy : l.jury_nominateHint),
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            DinerButton(
              key: const Key('jury-ready'),
              label: l.jury_ready(juror),
              style: DinerButtonStyle.mustard,
              onPressed: () => setState(() => _handOff = false),
            ),
          ] else if (!voting) ...[
            DinerHeading(l.jury_nominateTitle(juror)),
            const SizedBox(height: AppDimensions.spaceMd),
            DinerButton(
              label: l.jury_menu,
              icon: Icons.restaurant_menu_rounded,
              style: DinerButtonStyle.outline,
              onPressed: _pickFood,
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            TextField(
              key: const Key('jury-dish'),
              controller: _name,
              maxLength: 80,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.jury_dishName),
              onChanged: (_) => setState(() => _error = null),
            ),
            if (_error != null)
              Semantics(
                liveRegion: true,
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: AppDimensions.spaceMd),
            DinerButton(
              key: const Key('jury-nominate'),
              label: l.jury_nominate,
              style: DinerButtonStyle.mustard,
              onPressed: _name.text.trim().isEmpty ? null : _nominate,
            ),
          ] else ...[
            DinerHeading(l.jury_ballot(juror)),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(l.jury_ballotHint),
            const SizedBox(height: AppDimensions.spaceMd),
            for (final option in choices)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                child: DinerChoice(
                  key: ValueKey('jury-vote-${option.name}'),
                  label: option.name,
                  selected: _selectedVote == option.id,
                  onTap: () => setState(() => _selectedVote = option.id),
                ),
              ),
            const SizedBox(height: AppDimensions.spaceMd),
            DinerButton(
              key: const Key('jury-seal'),
              label: l.jury_seal,
              icon: Icons.mark_email_read_outlined,
              style: DinerButtonStyle.mustard,
              onPressed: _selectedVote == null
                  ? null
                  : () {
                      final vote = _selectedVote;
                      if (vote == null || session.complete) return;
                      session.vote(vote);
                      setState(() {
                        _selectedVote = null;
                        _handOff = true;
                      });
                    },
            ),
          ],
        ],
      ),
    );
  }
}
