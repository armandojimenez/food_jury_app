import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';

/// The maker's page, styled as a diner menu and preserving the original bio.
class AboutDeveloperScreen extends StatelessWidget {
  const AboutDeveloperScreen({super.key});

  Future<void> _open(BuildContext context, String url) async {
    try {
      if (!await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          ) &&
          context.mounted) {
        AppSnackbar.showError(
          context,
          message: context.l10n.error_genericMessage,
        );
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.showError(
          context,
          message: context.l10n.error_genericMessage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DinerScaffold(
      title: l.about_developer,
      child: LayoutBuilder(
        builder: (context, box) {
          final wide =
              box.maxWidth >= DinerTokens.tabletBreakpoint &&
              MediaQuery.textScalerOf(context).scale(1) <
                  DinerTokens.largeTextBreakpoint;
          final portrait = DinerEntrance(child: _MakerPortrait(wide: wide));
          final bio = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DinerSection(l.diner_behindCounter),
              const SizedBox(height: AppDimensions.spaceMd),
              DinerTicket(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.about_bioIntro,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    for (final text in [l.about_bioPassion, l.about_bioDrive])
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spaceMd,
                        ),
                        child: Text(text),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              DinerSection(l.diner_moreFromKitchen),
              const SizedBox(height: AppDimensions.spaceMd),
              for (final app in [
                (
                  l.about_appBelieve,
                  l.about_appBelieveSubtitle,
                  Icons.wb_sunny_outlined,
                ),
                (
                  l.about_appHoly,
                  l.about_appHolySubtitle,
                  Icons.menu_book_rounded,
                ),
                (
                  l.about_appUnique,
                  l.about_appUniqueSubtitle,
                  Icons.favorite_border_rounded,
                ),
                (
                  l.about_appMotiv,
                  l.about_appMotivSubtitle,
                  Icons.bolt_rounded,
                ),
                (
                  l.about_appDivine,
                  l.about_appDivineSubtitle,
                  Icons.auto_awesome_outlined,
                ),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                  child: DinerTicket(
                    padding: const EdgeInsets.all(AppDimensions.spaceMd),
                    child: Row(
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: AppColors.pop,
                            borderRadius: AppDimensions.borderRadiusSm,
                          ),
                          child: SizedBox.square(
                            dimension: DinerTokens.touchTarget,
                            child: Icon(app.$3, color: AppColors.accent),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app.$1,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(app.$2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: AppDimensions.spaceLg),
              DinerSection(l.about_connect),
              const SizedBox(height: AppDimensions.spaceMd),
              for (final contact in [
                (
                  l.about_contactWebsite,
                  'https://armandojimenez.dev',
                  Icons.language_rounded,
                ),
                (
                  l.about_contactGitHub,
                  'https://github.com/armandojimenez',
                  Icons.code_rounded,
                ),
                (
                  l.about_contactLinkedIn,
                  'https://linkedin.com/in/armando-jimenez-dev',
                  Icons.work_outline_rounded,
                ),
                (
                  l.about_contactEmail,
                  'mailto:contact@armandojimenez.dev',
                  Icons.mail_outline_rounded,
                ),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
                  child: DinerButton(
                    label: contact.$1,
                    icon: contact.$3,
                    style: DinerButtonStyle.outline,
                    onPressed: () => _open(context, contact.$2),
                  ),
                ),
            ],
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: portrait),
                const SizedBox(width: DinerTokens.columnGap),
                Expanded(flex: 6, child: bio),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              portrait,
              const SizedBox(height: AppDimensions.spaceXl),
              DinerEntrance(order: 1, child: bio),
            ],
          );
        },
      ),
    );
  }
}

class _MakerPortrait extends StatelessWidget {
  const _MakerPortrait({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final dimension = wide
        ? DinerTokens.tabletJudge
        : DinerTokens.makerPortrait;
    final largeText =
        MediaQuery.textScalerOf(context).scale(1) >=
        DinerTokens.largeTextBreakpoint;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DinerHeading(l.diner_aboutTitle, center: true, large: wide),
        const SizedBox(height: AppDimensions.spaceLg),
        SizedBox(
          height: dimension + AppDimensions.spaceLg,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                top: AppDimensions.spaceXxl,
                bottom: AppDimensions.spaceMd,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.pop,
                    borderRadius: AppDimensions.borderRadiusLg,
                    border: Border.all(
                      color: AppColors.accent,
                      width: DinerTokens.border,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.accent,
                        offset: Offset(DinerTokens.shadow, DinerTokens.shadow),
                      ),
                    ],
                  ),
                  child: const ClipRRect(
                    borderRadius: AppDimensions.borderRadiusLg,
                    child: DinerSunburst(color: AppColors.primary, opacity: .2),
                  ),
                ),
              ),
              const Positioned(
                left: AppDimensions.spaceSm,
                top: AppDimensions.spaceXl,
                child: DinerStar(size: AppDimensions.spaceXxxl),
              ),
              Positioned(
                right: AppDimensions.spaceSm,
                top: dimension * .3,
                child: const DinerRays(),
              ),
              Positioned.fill(
                bottom: AppDimensions.spaceMd,
                child: Semantics(
                  image: true,
                  label: l.about_developerName,
                  child: ExcludeSemantics(
                    child: Image.asset(
                      'assets/images/me-diner.png',
                      fit: BoxFit.contain,
                      cacheWidth:
                          (dimension * MediaQuery.devicePixelRatioOf(context))
                              .ceil(),
                    ),
                  ),
                ),
              ),
              if (!largeText)
                Positioned(
                  bottom: 0,
                  right: AppDimensions.spaceSm,
                  child: DinerStamp(l.diner_makerStamp, orange: true),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceLg),
        DinerHeading(l.about_developerName, center: true),
        const SizedBox(height: AppDimensions.spaceXs),
        Text(
          l.about_developerTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        Text(l.about_developerLocation, textAlign: TextAlign.center),
        const SizedBox(height: AppDimensions.spaceLg),
        DinerTicket(
          dashed: true,
          child: Text(
            l.about_bioClosing,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
