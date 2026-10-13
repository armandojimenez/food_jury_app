import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../../decision/data/models/verdict.dart';
import '../../food_library/data/food_catalog.dart';
import '../../lucky/presentation/court_components.dart';
import '../../lucky/presentation/winner_hero.dart';

/// Preview the exact receipt that will be exported, including the user's photo.
Future<void> showVerdictReceipt(BuildContext context, Verdict verdict) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: DinerTokens.sheetWidth),
      sheetAnimationStyle: reduceDinerMotion(context)
          ? AnimationStyle.noAnimation
          : null,
      builder: (_) => _ReceiptSheet(verdict: verdict),
    );

/// Capture only the receipt: never navigation, private notes, or sheet controls.
Future<Uint8List> captureVerdictReceipt(GlobalKey key) async {
  final boundary = key.currentContext?.findRenderObject();
  if (boundary is! RenderRepaintBoundary) {
    throw StateError('The receipt is not ready to share.');
  }
  final image = await boundary.toImage(pixelRatio: 2);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    if (data == null) throw StateError('The receipt could not be prepared.');
    return data.buffer.asUint8List();
  } finally {
    image.dispose();
  }
}

String verdictShareText(BuildContext context, Verdict verdict) {
  final l = context.l10n;
  final method = verdict.random?.method.title(context) ?? l.lucky_ai;
  return '${l.diner_wins(verdict.winner.name)}\n\n'
      '${verdict.displayRuling}\n\n'
      '$method · ${verdict.objective.getLabel(context)}\n'
      '${l.lucky_caseDetails}: ${verdict.caseOptions.map((o) => o.name).join(' · ')}\n'
      '${verdict.isRandom ? '${l.lucky_equalOdds}\n' : ''}FoodJury';
}

class _ReceiptSheet extends StatefulWidget {
  const _ReceiptSheet({required this.verdict});
  final Verdict verdict;
  @override
  State<_ReceiptSheet> createState() => _ReceiptSheetState();
}

class _ReceiptSheetState extends State<_ReceiptSheet> {
  final _receiptKey = GlobalKey();
  final _imageButtonKey = GlobalKey();
  final _textButtonKey = GlobalKey();
  bool _sharing = false;
  Future<void> _prepareAssets() async {
    final winner = widget.verdict.winner;
    final art =
        foodArtById(winner.illustrationId)?.asset ??
        foodIllustrationFor(winner.name);
    final receiptWidth = _receiptKey.currentContext!.size!.width;
    final heroWidth = receiptWidth - AppDimensions.spaceLg * 2;
    final ratio = MediaQuery.devicePixelRatioOf(context);
    await Future.wait([
      precacheImage(
        const AssetImage('assets/images/brand/foodjury-wordmark.png'),
        context,
      ),
      // Match the exact resize keys used by WinnerHero before capturing it.
      precacheImage(
        ResizeImage(
          AssetImage('assets/images/food_illustrations/$art.png'),
          width: (heroWidth * .75 * ratio).ceil(),
        ),
        context,
      ),
      precacheImage(
        ResizeImage(
          const AssetImage('assets/images/judge_bite_v2/celebrating.png'),
          width: (heroWidth * (winner.hasImage ? .35 : .43) * ratio).ceil(),
        ),
        context,
      ),
      if (winner.hasImage)
        precacheImage(
          ResizeImage(
            MemoryImage(winner.imageBytes!),
            width: DinerTokens.photoDecodeWidth,
          ),
          context,
        ),
    ]);
  }

  Future<void> _share({required bool image}) async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final text = verdictShareText(context, widget.verdict);
      Uint8List? bytes;
      if (image) {
        await _prepareAssets();
        await WidgetsBinding.instance.endOfFrame;
        if (!mounted) return;
        bytes = await captureVerdictReceipt(_receiptKey);
      }
      if (!mounted) return;
      final box =
          (image ? _imageButtonKey : _textButtonKey).currentContext
                  ?.findRenderObject()
              as RenderBox?;
      // The button belongs to this visible sheet, keeping iPad popovers valid.
      final origin = box == null
          ? Rect.fromLTWH(0, 0, 1, 1)
          : box.localToGlobal(Offset.zero) & box.size;
      await SharePlus.instance.share(
        ShareParams(
          title: 'FoodJury',
          text: image ? null : text,
          files: bytes == null
              ? null
              : [XFile.fromData(bytes, mimeType: 'image/png')],
          fileNameOverrides: bytes == null ? null : ['foodjury-verdict.png'],
          sharePositionOrigin: origin,
        ),
      );
    } catch (_) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          message: context.l10n.moments_shareError,
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: DinerHeading(context.l10n.moments_shareTitle)),
              DinerIconButton(
                label: context.l10n.common_close,
                icon: Icons.close_rounded,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(context.l10n.moments_shareHint),
          const SizedBox(height: AppDimensions.spaceLg),
          RepaintBoundary(
            key: _receiptKey,
            child: VerdictReceipt(verdict: widget.verdict),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          DinerButton(
            key: _imageButtonKey,
            label: context.l10n.moments_shareImage,
            icon: Icons.ios_share_rounded,
            style: DinerButtonStyle.mustard,
            loading: _sharing,
            onPressed: () => _share(image: true),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          TextButton(
            key: _textButtonKey,
            onPressed: _sharing ? null : () => _share(image: false),
            child: Text(context.l10n.moments_shareText),
          ),
        ],
      ),
    ),
  );
}

/// Print-style artwork; every name and ruling remains live, wrapping text.
class VerdictReceipt extends StatelessWidget {
  const VerdictReceipt({required this.verdict, super.key});
  final Verdict verdict;

  @override
  Widget build(BuildContext context) => Theme(
    data: AppTheme.light,
    child: Builder(
      builder: (context) {
        final l = context.l10n;
        return DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: Container(
            key: const Key('verdict-receipt'),
            decoration: const BoxDecoration(color: AppColors.background),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceMd),
                  color: AppColors.primary,
                  child: const Center(child: DinerWordmark()),
                ),
                const CheckerboardTrim(),
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.spaceLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: DinerStamp(l.diner_caseClosed)),
                      const SizedBox(height: AppDimensions.spaceMd),
                      DinerHeading(
                        l.diner_wins(verdict.winner.name),
                        center: true,
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),
                      WinnerHero(option: verdict.winner),
                      const SizedBox(height: AppDimensions.spaceLg),
                      DinerTicket(
                        dashed: true,
                        child: Text(
                          '“${verdict.displayRuling}”',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      Text(
                        verdict.random?.method.title(context) ?? l.lucky_ai,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        verdict.objective.getLabel(context),
                        textAlign: TextAlign.center,
                      ),
                      if (verdict.isRandom) ...[
                        const SizedBox(height: AppDimensions.spaceSm),
                        Text(l.lucky_equalOdds, textAlign: TextAlign.center),
                      ],
                      const Divider(height: AppDimensions.spaceXl),
                      Text(
                        l.lucky_caseDetails,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.spaceSm),
                      for (final (index, option) in verdict.caseOptions.indexed)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.spaceXs,
                          ),
                          child: Text('${index + 1}. ${option.name}'),
                        ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      Text(
                        l.moments_receiptFooter,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const CheckerboardTrim(),
              ],
            ),
          ),
        );
      },
    ),
  );
}
