import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/env/env.dart';
import '../../../core/providers/judge_tone_provider.dart';
import '../../../core/providers/mock_ai_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../decision/data/models/verdict.dart';
import '../../lucky/presentation/ai_allowance_ticket.dart';

/// Personalization lives in the same diner system as the food case flow.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tone = ref.watch(judgeToneProvider);
    final theme = ref.watch(themeNotifierProvider);
    final l = context.l10n;
    final labels = [
      l.tone_stern,
      l.tone_sassy,
      l.tone_enthusiastic,
      l.tone_chill,
    ];
    final previews = [
      l.tone_sternPreview,
      l.tone_sassyPreview,
      l.tone_enthusiasticPreview,
      l.tone_chillPreview,
    ];
    final poses = [
      JudgeBitePose.stern,
      JudgeBitePose.thinking,
      JudgeBitePose.excited,
      JudgeBitePose.idle,
    ];
    return DinerScaffold(
      title: l.settings_screenTitle,
      child: LayoutBuilder(
        builder: (context, box) {
          final wide =
              box.maxWidth >= DinerTokens.tabletBreakpoint &&
              MediaQuery.textScalerOf(context).scale(1) <
                  DinerTokens.largeTextBreakpoint;
          final intro = DinerEntrance(
            child: Column(
              children: [
                DinerHeading(l.diner_settingsTitle, center: true, large: wide),
                const SizedBox(height: AppDimensions.spaceSm),
                Text(l.diner_settingsSubtitle, textAlign: TextAlign.center),
                const SizedBox(height: AppDimensions.spaceMd),
                DinerCharacterStage(
                  pose: poses[tone.index],
                  large: wide,
                  bubble: labels[tone.index],
                  footer: DinerTicket(
                    dashed: true,
                    child: Text(
                      previews[tone.index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
            ),
          );
          final controls = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AiAllowanceTicket(),
              const SizedBox(height: AppDimensions.spaceLg),
              DinerSection(l.settings_judgePersonality),
              const SizedBox(height: AppDimensions.spaceSm),
              Text(l.diner_personalityHint),
              const SizedBox(height: AppDimensions.spaceMd),
              for (final value in JudgeTone.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                  child: DinerChoice(
                    label: labels[value.index],
                    selected: tone == value,
                    onTap: () async {
                      try {
                        await ref
                            .read(judgeToneProvider.notifier)
                            .select(value);
                      } catch (error) {
                        if (context.mounted) {
                          AppSnackbar.showError(
                            context,
                            message: l.error_genericMessage,
                          );
                        }
                      }
                    },
                  ),
                ),
              const SizedBox(height: AppDimensions.spaceLg),
              DinerSection(l.settings_appearance),
              const SizedBox(height: AppDimensions.spaceMd),
              Wrap(
                spacing: AppDimensions.spaceSm,
                runSpacing: AppDimensions.spaceSm,
                children: [
                  for (final mode in ThemeMode.values)
                    SizedBox(
                      width: DinerTokens.appearanceChoice,
                      child: DinerChoice(
                        label: switch (mode) {
                          ThemeMode.light => l.theme_light,
                          ThemeMode.dark => l.theme_dark,
                          ThemeMode.system => l.theme_system,
                        },
                        selected: theme == mode,
                        onTap: () async {
                          try {
                            await ref
                                .read(themeNotifierProvider.notifier)
                                .setThemeMode(mode);
                          } catch (error) {
                            if (context.mounted) {
                              AppSnackbar.showError(
                                context,
                                message: l.error_genericMessage,
                              );
                            }
                          }
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              DinerSection(l.settings_about),
              const SizedBox(height: AppDimensions.spaceMd),
              DinerTicket(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l.about_foodJuryDescription),
                    const SizedBox(height: AppDimensions.spaceMd),
                    DinerButton(
                      label: l.about_meetDeveloper,
                      style: DinerButtonStyle.outline,
                      onPressed: () => context.push(AppRouter.aboutDeveloper),
                    ),
                    const SizedBox(height: AppDimensions.spaceSm),
                    Text(l.settings_madeWithLove, textAlign: TextAlign.center),
                  ],
                ),
              ),
              if (Env.isDev) ...[
                const SizedBox(height: AppDimensions.spaceLg),
                DinerSection(l.settings_devSection),
                const SizedBox(height: AppDimensions.spaceMd),
                DinerTicket(
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l.settings_useMockAi),
                        subtitle: Text(l.settings_useMockAiDescription),
                        value: ref.watch(mockAiNotifierProvider),
                        onChanged: (value) => ref
                            .read(mockAiNotifierProvider.notifier)
                            .setUseMockAi(value),
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),
                      DinerButton(
                        label: context.l10n.diner_kitchen,
                        icon: Icons.palette_outlined,
                        style: DinerButtonStyle.outline,
                        onPressed: () => context.push(AppRouter.devSettings),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: intro),
                const SizedBox(width: DinerTokens.columnGap),
                Expanded(child: controls),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              intro,
              const SizedBox(height: AppDimensions.spaceXl),
              DinerEntrance(order: 1, child: controls),
            ],
          );
        },
      ),
    );
  }
}
