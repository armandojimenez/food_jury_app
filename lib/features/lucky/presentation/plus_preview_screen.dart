import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';

/// Approved price presentation. Purchasing is deliberately not simulated.
class PlusPreviewScreen extends StatefulWidget {
  const PlusPreviewScreen({super.key});
  @override
  State<PlusPreviewScreen> createState() => _PlusPreviewScreenState();
}

class _PlusPreviewScreenState extends State<PlusPreviewScreen> {
  bool _yearly = true;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DinerScaffold(
      title: l.plus_hint,
      maxWidth: DinerTokens.readingWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DinerEntrance(child: DinerHeading(l.plus_title)),
          const SizedBox(height: AppDimensions.spaceMd),
          const JudgeBite(
            pose: JudgeBitePose.pointing,
            dimension: DinerTokens.heroJudge,
          ),
          DinerTicket(
            dashed: true,
            child: Column(
              children: [
                DinerHeading(l.plus_unlimited),
                const SizedBox(height: AppDimensions.spaceMd),
                Text(l.plus_details, textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          DinerChoice(
            label: '${l.plus_year}\n${l.plus_value}',
            selected: _yearly,
            onTap: () => setState(() => _yearly = true),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          DinerChoice(
            label: l.plus_month,
            selected: !_yearly,
            onTap: () => setState(() => _yearly = false),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          DinerTicket(
            child: Column(
              children: [
                Text(
                  l.plus_preview,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                Text(l.plus_notConnected, textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          DinerButton(
            label: l.plus_continueFree,
            style: DinerButtonStyle.mustard,
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(AppRouter.home),
          ),
        ],
      ),
    );
  }
}
