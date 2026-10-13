import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/app_router.dart';
import '../../case_shelf/data/case_shelf_provider.dart';
import '../data/onboarding_store.dart';

/// Completes the tour only on offer exit, preserving an unfinished case.
Future<void> completeOnboarding(BuildContext context, WidgetRef ref) async {
  final draft = (await ref.read(caseShelfProvider.future)).draft;
  if (!context.mounted) return;
  await OnboardingStore.complete();
  if (context.mounted) context.go(AppRouter.newDecision, extra: draft);
}
