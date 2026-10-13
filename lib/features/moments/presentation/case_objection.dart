import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../decision/data/models/verdict.dart';
import '../../case_shelf/data/case_shelf_models.dart';
import '../../case_shelf/presentation/case_shelf_widgets.dart';
import '../../lucky/data/decision_case.dart';

/// Reopens a snapshot as a new case, leaving the accepted ruling untouched.
Future<void> showCaseObjection(
  BuildContext context,
  WidgetRef ref,
  Verdict verdict,
) async {
  final choice = await AppBottomSheet.show<bool>(
    context,
    child: Builder(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DinerHeading(context.l10n.moments_objectionTitle, center: true),
          JudgeAside(
            moment: JudgeMoment.objection,
            eventId: verdict.id,
            compact: true,
          ),
          Text(context.l10n.moments_objectionHint, textAlign: TextAlign.center),
          const SizedBox(height: AppDimensions.spaceLg),
          DinerButton(
            key: const Key('objection-edit'),
            label: context.l10n.lucky_editCase,
            style: DinerButtonStyle.mustard,
            icon: Icons.edit_outlined,
            onPressed: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          DinerButton(
            key: const Key('objection-method'),
            label: context.l10n.lucky_otherMethod,
            style: DinerButtonStyle.outline,
            onPressed: () => Navigator.pop(context, false),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.moments_objectionAccept),
          ),
        ],
      ),
    ),
  );
  if (choice == null || !context.mounted) return;
  final caseData = DecisionCase(
    options: verdict.caseOptions,
    objective: verdict.objective,
  );
  if (choice) {
    await openShelfCase(context, ref, draft: CaseDraft.fromCase(caseData));
  } else {
    await context.push(AppRouter.methods, extra: caseData);
  }
}
