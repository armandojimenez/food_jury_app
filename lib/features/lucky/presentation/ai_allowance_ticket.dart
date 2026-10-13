import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../data/court_providers.dart';

/// The AI allowance and always-free alternative, visible before starting a case.
class AiAllowanceTicket extends ConsumerWidget {
  const AiAllowanceTicket({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final premium = ref.watch(premiumAccessProvider);
    final allowance = ref.watch(aiAllowanceProvider);
    return DinerTicket(
      dashed: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (premium)
            Text(
              l.plus_unlimited,
              style: Theme.of(context).textTheme.titleMedium,
            )
          else
            allowance.when(
              data: (remaining) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceXs,
                          ),
                          child: Icon(
                            i < remaining
                                ? Icons.local_activity_rounded
                                : Icons.check_circle_outline,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: DinerTokens.sectionType,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceSm),
                  Text(
                    l.lucky_remaining(remaining),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, stack) => Column(
                children: [
                  Text(
                    l.moments_allowanceUnavailable,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(aiAllowanceProvider),
                    child: Text(l.common_retry),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(l.lucky_freeHint, textAlign: TextAlign.center),
          if (!premium)
            TextButton(
              onPressed: () => context.push(AppRouter.plus),
              child: Text(l.plus_explore),
            ),
        ],
      ),
    );
  }
}
