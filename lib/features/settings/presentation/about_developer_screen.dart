import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';

/// About Developer Screen - beautiful retro-styled developer profile.
///
/// Features:
/// - Developer photo with retro frame
/// - Professional summary
/// - Skills showcase
/// - Published apps with download stats
/// - Contact links
class AboutDeveloperScreen extends StatelessWidget {
  const AboutDeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppRetroAppBar(
        title: context.l10n.about_developer,
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.screenPadding,
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.spaceMd),

            // Developer Photo & Header
            _DeveloperHeader()
                .animate()
                .fadeIn(duration: AppDimensions.durationMedium)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                  duration: AppDimensions.durationMedium,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: AppDimensions.spaceXl),

            // Bio Section
            _BioSection()
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 100),
                )
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppDimensions.spaceXl),

            // Stats Card
            _StatsCard()
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 200),
                )
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppDimensions.spaceXl),

            // Published Apps
            _PublishedAppsSection()
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 300),
                )
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppDimensions.spaceXl),

            // About FoodJury
            _AboutFoodJurySection()
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 400),
                )
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppDimensions.spaceXl),

            // Contact Section
            _ContactSection()
                .animate()
                .fadeIn(
                  duration: AppDimensions.durationMedium,
                  delay: const Duration(milliseconds: 500),
                )
                .slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppDimensions.spaceXxl),
          ],
        ),
      ),
    );
  }
}

/// Developer header with photo and title.
class _DeveloperHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Photo with retro frame
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceSm),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border.all(
              color: colorScheme.primary,
              width: AppDimensions.borderThick,
            ),
            borderRadius: AppDimensions.borderRadiusMd,
            boxShadow: AppDimensions.shadowRetro,
          ),
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: AppDimensions.borderRadiusSm,
              border: Border.all(
                color: colorScheme.secondary,
                width: AppDimensions.borderMedium,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusSm - AppDimensions.borderMedium,
              ),
              child: Image.asset(
                'assets/images/me.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spaceLg),

        // Name
        Text(
          'Armando Jiménez',
          style: AppTypography.displaySmall.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spaceXs),

        // Title badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: AppDimensions.spaceXs,
          ),
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: AppDimensions.borderRadiusPill,
            border: Border.all(
              color: colorScheme.secondary,
              width: AppDimensions.borderMedium,
            ),
          ),
          child: Text(
            'MOBILE DEVELOPER',
            style: AppTypography.labelMedium.copyWith(
              color: colorScheme.onSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spaceSm),

        // Location
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: AppDimensions.iconSizeSm,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppDimensions.spaceXxs),
            Text(
              'Carolina, Puerto Rico 🇵🇷',
              style: AppTypography.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Bio section with professional summary.
class _BioSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_outline,
                color: colorScheme.primary,
                size: AppDimensions.iconSizeMd,
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Text(
                l10n.about_aboutMe,
                style: AppTypography.titleMedium.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            "Hey! I'm Armando, a mobile developer from Carolina, Puerto Rico. 🇵🇷",
            style: AppTypography.bodyLarge.copyWith(
              color: colorScheme.onSurface,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            "I have a deep passion for building apps that make people smile, feel positive, and maybe even change the way they see the world. Whether it's a fun tool, something for mental wellness, or just an app that brings a little joy to your day, I pour my heart into everything I create.",
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            "What drives me? Knowing that something I built might be used by millions of people around the world. That someone in another country might open my app and feel a little bit better. That's the magic of mobile development, and I'm grateful to be part of it.",
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            "Everything I create is made with love, from Puerto Rico to the world. 🌴❤️",
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stats card showing achievements.
class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: AppDimensions.borderRadiusMd,
        border: Border.all(
          color: colorScheme.secondary,
          width: AppDimensions.borderThick,
        ),
        boxShadow: AppDimensions.shadowRetro,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(value: '10+', label: 'YEARS', icon: Icons.favorite),
          _VerticalDivider(),
          _StatItem(value: '500K+', label: 'USERS', icon: Icons.people),
          _VerticalDivider(),
          _StatItem(value: '∞', label: 'LOVE', icon: Icons.auto_awesome),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(
          icon,
          color: colorScheme.onPrimary.withValues(alpha: 0.7),
          size: AppDimensions.iconSizeSm,
        ),
        const SizedBox(height: AppDimensions.spaceXxs),
        Text(
          value,
          style: AppTypography.headlineMedium.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: colorScheme.onPrimary.withValues(alpha: 0.8),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 50,
      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
    );
  }
}

/// Published apps showcase.
class _PublishedAppsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.rocket_launch_outlined,
              color: colorScheme.primary,
              size: AppDimensions.iconSizeMd,
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Text(
              l10n.about_publishedApps,
              style: AppTypography.titleMedium.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        _AppCard(
          name: 'Believe',
          subtitle: 'Daily Affirmations',
          rating: '4.8',
          downloads: '200K+',
          emoji: '✨',
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        _AppCard(
          name: 'Holy',
          subtitle: 'Daily Bible Verses',
          rating: '4.9',
          downloads: '75K+',
          emoji: '📖',
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        _AppCard(
          name: 'Unique',
          subtitle: 'Self-Love Reminders',
          rating: '4.7',
          downloads: '60K+',
          emoji: '💜',
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        _AppCard(
          name: 'Motiv',
          subtitle: 'Inspirational Quotes',
          rating: '4.7',
          downloads: '25K+',
          emoji: '💪',
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        _AppCard(
          name: 'Divine',
          subtitle: 'Angel Messages',
          rating: '4.9',
          downloads: '15K+',
          emoji: '👼',
        ),
      ],
    );
  }
}

class _AppCard extends StatelessWidget {
  const _AppCard({
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.downloads,
    required this.emoji,
  });

  final String name;
  final String subtitle;
  final String rating;
  final String downloads;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimensions.borderRadiusSm,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: AppDimensions.borderMedium,
        ),
      ),
      child: Row(
        children: [
          // Emoji icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppDimensions.borderRadiusSm,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          // App info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Stats
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 14, color: colorScheme.tertiary),
                  const SizedBox(width: 2),
                  Text(
                    rating,
                    style: AppTypography.labelMedium.copyWith(
                      color: colorScheme.tertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                downloads,
                style: AppTypography.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// About FoodJury section.
class _AboutFoodJurySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              JudgeBite(pose: JudgeBitePose.waving, size: JudgeBiteSize.small),
              const SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.about_aboutFoodJury,
                      style: AppTypography.titleMedium.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'v1.0.0',
                      style: AppTypography.labelSmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            l10n.about_foodJuryDescription,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          // Tech stack
          Wrap(
            spacing: AppDimensions.spaceSm,
            runSpacing: AppDimensions.spaceSm,
            children: const [
              _TechBadge(label: 'Flutter'),
              _TechBadge(label: 'Riverpod'),
              _TechBadge(label: 'Firebase'),
              _TechBadge(label: 'Gemini AI'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TechBadge extends StatelessWidget {
  const _TechBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSm,
        vertical: AppDimensions.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.tertiary.withValues(alpha: 0.15),
        borderRadius: AppDimensions.borderRadiusSm,
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: colorScheme.tertiary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Contact section with links.
class _ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.connect_without_contact_outlined,
              color: colorScheme.primary,
              size: AppDimensions.iconSizeMd,
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Text(
              l10n.about_connect,
              style: AppTypography.titleMedium.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Row(
          children: [
            Expanded(
              child: _ContactButton(
                icon: Icons.language,
                label: 'Website',
                onTap: () => _launchUrl('https://armandojimenez.dev'),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Expanded(
              child: _ContactButton(
                icon: Icons.code,
                label: 'GitHub',
                onTap: () => _launchUrl('https://github.com/armandojimenez'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        Row(
          children: [
            Expanded(
              child: _ContactButton(
                icon: Icons.work_outline,
                label: 'LinkedIn',
                onTap: () =>
                    _launchUrl('https://linkedin.com/in/armando-jimenez-dev'),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            Expanded(
              child: _ContactButton(
                icon: Icons.email_outlined,
                label: 'Email',
                onTap: () => _launchUrl('mailto:contact@armandojimenez.dev'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: AppDimensions.borderRadiusSm,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensions.borderRadiusSm,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: AppDimensions.spaceMd,
          ),
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderRadiusSm,
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: AppDimensions.borderMedium,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimensions.iconSizeMd,
                color: colorScheme.primary,
              ),
              const SizedBox(width: AppDimensions.spaceSm),
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
