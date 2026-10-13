import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ai_consent_provider.dart';
import '../theme/theme.dart';
import '../utils/l10n_extensions.dart';
import 'widgets.dart';

/// The affirmative action persists this exact policy before a Smart request.
Future<bool> ensureAiDataConsent(BuildContext context, WidgetRef ref) async {
  try {
    if (await ref.read(aiConsentProvider.notifier).acceptedVersion() ==
        aiConsentVersion) {
      return true;
    }
  } catch (_) {
    // The sheet can retry storing an explicit decision; never infer permission.
  }
  if (!context.mounted) return false;
  return await _showPermission(context, review: false) ?? false;
}

/// Settings reviews the same disclosure and can withdraw future permission.
Future<void> reviewAiDataConsent(BuildContext context) async {
  await _showPermission(context, review: true);
}

Future<bool?> _showPermission(BuildContext context, {required bool review}) =>
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      sheetAnimationStyle: reduceDinerMotion(context)
          ? AnimationStyle.noAnimation
          : null,
      builder: (_) => _AiConsentSheet(review: review),
    );

class _AiConsentSheet extends ConsumerStatefulWidget {
  const _AiConsentSheet({required this.review});
  final bool review;

  @override
  ConsumerState<_AiConsentSheet> createState() => _AiConsentSheetState();
}

class _AiConsentSheetState extends ConsumerState<_AiConsentSheet> {
  bool _busy = false, _failed = false;

  Future<void> _save({required bool accept}) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      final notifier = ref.read(aiConsentProvider.notifier);
      if (accept) {
        await notifier.accept();
      } else {
        await notifier.revoke();
      }
      if (mounted) Navigator.pop(context, accept && !widget.review);
    } catch (_) {
      if (mounted) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final accepted = ref.watch(aiConsentProvider) == aiConsentVersion;
    return PopScope(
      canPop: !_busy,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          key: const Key('ai-consent-sheet'),
          padding: const EdgeInsets.all(DinerTokens.pageInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: JudgeBite(
                  pose: JudgeBitePose.inspecting,
                  size: JudgeBiteSize.small,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              DinerHeading(
                widget.review ? l.consent_settingsTitle : l.consent_title,
                center: true,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(l.consent_data),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(l.consent_recipients),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(l.consent_identity),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(l.consent_control),
              if (widget.review) ...[
                const SizedBox(height: AppDimensions.spaceMd),
                DinerTicket(
                  child: Text(
                    accepted ? l.consent_allowed : l.consent_notAllowed,
                  ),
                ),
              ],
              if (_failed) ...[
                const SizedBox(height: AppDimensions.spaceMd),
                Semantics(liveRegion: true, child: Text(l.consent_saveError)),
              ],
              const SizedBox(height: AppDimensions.spaceLg),
              if (!widget.review)
                DinerButton(
                  key: const Key('consent-send'),
                  label: l.consent_send,
                  loading: _busy,
                  onPressed: _busy ? null : () => _save(accept: true),
                )
              else if (accepted || _failed)
                DinerButton(
                  key: const Key('consent-revoke'),
                  label: l.consent_revoke,
                  style: DinerButtonStyle.outline,
                  loading: _busy,
                  onPressed: _busy ? null : () => _save(accept: false),
                ),
              const SizedBox(height: AppDimensions.spaceSm),
              TextButton(
                key: Key(widget.review ? 'consent-done' : 'consent-not-now'),
                onPressed: _busy ? null : () => Navigator.pop(context, false),
                child: Text(widget.review ? l.common_close : l.consent_notNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
