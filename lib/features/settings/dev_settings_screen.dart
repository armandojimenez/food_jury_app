import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/app_router.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/l10n_extensions.dart';
import '../../core/widgets/widgets.dart';
import '../decision/data/models/food_option.dart';
import '../decision/data/models/objective.dart';
import '../decision/data/models/verdict.dart';

/// Living reference for new screens, all mascot expressions and the reveal.
class DevSettingsScreen extends StatelessWidget {
  const DevSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => DinerScaffold(
    title: context.l10n.diner_kitchen,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DinerHeading(context.l10n.diner_demo),
        const SizedBox(height: AppDimensions.spaceSm),
        Text(context.l10n.diner_demoHint),
        const SizedBox(height: AppDimensions.spaceLg),
        DinerSection(context.l10n.diner_cast),
        const SizedBox(height: AppDimensions.spaceMd),
        LayoutBuilder(
          builder: (context, box) {
            final largeText =
                MediaQuery.textScalerOf(context).scale(1) >=
                DinerTokens.largeTextBreakpoint;
            final columns = largeText
                ? 1
                : (box.maxWidth / 190).floor().clamp(2, 5);
            final width =
                (box.maxWidth - AppDimensions.spaceMd * (columns - 1)) /
                columns;
            final labels = [
              context.l10n.diner_poseIdle,
              context.l10n.diner_poseThinking,
              context.l10n.diner_poseExcited,
              context.l10n.diner_poseStern,
              context.l10n.diner_poseConfused,
              context.l10n.diner_poseCelebrating,
              context.l10n.diner_poseSleeping,
              context.l10n.diner_poseEating,
              context.l10n.diner_posePointing,
              context.l10n.diner_poseWaving,
              context.l10n.lucky_wheel,
              context.l10n.lucky_ticket,
              context.l10n.judge_poseInspecting,
              context.l10n.judge_poseBench,
              context.l10n.judge_poseObjection,
              context.l10n.judge_poseFiling,
              context.l10n.judge_poseBell,
              context.l10n.judge_poseWhispering,
            ];
            return Wrap(
              spacing: AppDimensions.spaceMd,
              runSpacing: AppDimensions.spaceMd,
              children: [
                for (final pose in JudgeBitePose.values)
                  SizedBox(
                    width: width,
                    child: DinerTicket(
                      child: Column(
                        children: [
                          JudgeBiteAnimated(
                            pose: pose,
                            dimension: width - AppDimensions.spaceLg,
                          ),
                          Text(
                            labels[pose.index],
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: AppDimensions.spaceXl),
        DinerSection(context.l10n.diner_demoActions),
        const SizedBox(height: AppDimensions.spaceMd),
        DinerButton(
          label: context.l10n.diner_replay,
          icon: Icons.gavel_rounded,
          onPressed: () => context.push(
            AppRouter.verdict,
            extra: Verdict(
              id: 'design-kitchen-preview',
              winner: FoodOption(
                id: 'preview-a',
                name: context.l10n.diner_demoFood,
              ),
              rankings: [
                FoodOption(id: 'preview-a', name: context.l10n.diner_demoFood),
              ],
              reasoning: context.l10n.diner_demoReasoning,
              objective: Objective.fun,
              judgeTone: JudgeTone.enthusiastic,
              createdAt: DateTime.now(),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        DinerButton(
          label: context.l10n.diner_demoDialog,
          style: DinerButtonStyle.mustard,
          onPressed: () => AppDialog.showConfirmation(
            context,
            title: context.l10n.diner_deleteCase,
            message: context.l10n.diner_deleteCaseHint,
            confirmText: context.l10n.common_delete,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        DinerButton(
          label: context.l10n.diner_demoSheet,
          style: DinerButtonStyle.outline,
          onPressed: () => AppBottomSheet.show<void>(
            context,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const JudgeBite(
                  pose: JudgeBitePose.waving,
                  size: JudgeBiteSize.large,
                ),
                DinerHeading(context.l10n.diner_welcome),
                const SizedBox(height: AppDimensions.spaceLg),
                Text(context.l10n.diner_demoHint),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXl),
        DinerTicket(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DinerHeading(context.l10n.diner_homeTitle),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(
                context.l10n.diner_homeSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              DinerStamp(context.l10n.diner_approved),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXl),
      ],
    ),
  );
}
