import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/court_feedback.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../data/food_catalog.dart';

/// Searchable art menu, including broad categories for off-menu dishes.
class FoodLibraryScreen extends ConsumerStatefulWidget {
  const FoodLibraryScreen({
    super.key,
    this.selectedId,
    this.multiSelect = false,
    this.minimumSelections = 2,
    this.maximumSelections = 5,
  });

  /// Select a full lineup instead of a single decorative illustration.
  final bool multiSelect;
  final int minimumSelections;
  final int maximumSelections;
  final String? selectedId;
  @override
  ConsumerState<FoodLibraryScreen> createState() => _FoodLibraryScreenState();
}

class _FoodLibraryScreenState extends ConsumerState<FoodLibraryScreen> {
  String _query = '', _group = 'all';
  final _search = TextEditingController();
  final _selected = <String>{};
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _isSelected(FoodArt art) => widget.multiSelect
      ? _selected.contains(art.id)
      : art.id == widget.selectedId;

  bool _canSelect(FoodArt art) =>
      !widget.multiSelect ||
      _selected.contains(art.id) ||
      _selected.length < widget.maximumSelections;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final language = Localizations.localeOf(context).languageCode;
    final groups = {
      'all': l.library_all,
      'favorites': l.library_favorites,
      'lighter': l.library_lighter,
      'comfort': l.library_comfort,
      'breakfast': l.library_breakfast,
      'sweet': l.library_sweet,
      if (!widget.multiSelect) 'categories': l.library_categories,
    };
    final matches = foodCatalog
        .where(
          (art) =>
              art.matches(_query) &&
              (!widget.multiSelect || !art.generic) &&
              (_group == 'all' || art.group == _group),
        )
        .toList();
    return DinerScaffold(
      title: widget.multiSelect ? l.shelf_quickMenu : l.library_title,
      bottomAction: widget.multiSelect
          ? DinerButton(
              key: const Key('add-menu-selection'),
              label: l.shelf_addSelected(_selected.length),
              style: DinerButtonStyle.mustard,
              onPressed: _selected.length >= widget.minimumSelections
                  ? () => Navigator.pop(context, [
                      for (final id in _selected)
                        foodCatalog.firstWhere((art) => art.id == id),
                    ])
                  : null,
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DinerEntrance(
            child: DinerHeading(
              widget.multiSelect ? l.shelf_quickHint : l.library_hint,
            ),
          ),
          if (widget.multiSelect) ...[
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              l.shelf_menuLimit(
                widget.minimumSelections,
                widget.maximumSelections,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Semantics(
              liveRegion: true,
              child: Text(
                l.shelf_selectedCount(
                  _selected.length,
                  widget.maximumSelections,
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.spaceMd),
          TextField(
            key: const Key('food-library-search'),
            controller: _search,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: l.library_search,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: l.common_close,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        _search.clear();
                        setState(() => _query = '');
                      },
                    ),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Wrap(
            spacing: AppDimensions.spaceSm,
            runSpacing: AppDimensions.spaceSm,
            children: [
              for (final group in groups.entries)
                FilterChip(
                  label: Text(group.value),
                  selected: _group == group.key,
                  onSelected: (_) => setState(() => _group = group.key),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          if (matches.isEmpty) ...[
            const JudgeBite(
              pose: JudgeBitePose.confused,
              dimension: DinerTokens.rulingJudge,
            ),
            DinerHeading(l.library_empty),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              widget.multiSelect ? l.shelf_noMenuMatch : l.library_genericHint,
            ),
            const SizedBox(height: AppDimensions.spaceLg),
          ],
          LayoutBuilder(
            builder: (context, box) {
              final largeText =
                  MediaQuery.textScalerOf(context).scale(1) >=
                  DinerTokens.largeTextBreakpoint;
              final columns = largeText
                  ? 1
                  : box.maxWidth >= DinerTokens.tabletBreakpoint
                  ? 4
                  : 2;
              final width =
                  (box.maxWidth - (columns - 1) * AppDimensions.spaceMd) /
                  columns;
              final items = matches.isEmpty
                  ? foodCatalog.where((a) => !widget.multiSelect && a.generic)
                  : matches;
              return Wrap(
                spacing: AppDimensions.spaceMd,
                runSpacing: AppDimensions.spaceMd,
                children: [
                  for (final art in items)
                    SizedBox(
                      width: width,
                      child: Semantics(
                        button: true,
                        selected: _isSelected(art),
                        enabled: _canSelect(art),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            key: ValueKey('food-art-${art.id}'),
                            enableFeedback: false,
                            borderRadius: AppDimensions.borderRadiusMd,
                            onTap: !_canSelect(art)
                                ? null
                                : () {
                                    CourtFeedback.play(
                                      context,
                                      ref,
                                      CourtCue.selection,
                                    );
                                    if (!widget.multiSelect) {
                                      Navigator.pop(context, art);
                                    } else {
                                      setState(() {
                                        if (!_selected.remove(art.id)) {
                                          _selected.add(art.id);
                                        }
                                      });
                                    }
                                  },
                            child: DinerTicket(
                              color: _isSelected(art) ? AppColors.pop : null,
                              padding: const EdgeInsets.all(
                                AppDimensions.spaceMd,
                              ),
                              child: Column(
                                children: [
                                  FoodIllustration(
                                    name: art.en,
                                    illustrationId: art.id,
                                    size: largeText
                                        ? DinerTokens.thumbnail
                                        : DinerTokens.rulingJudge,
                                  ),
                                  const SizedBox(height: AppDimensions.spaceSm),
                                  Text(
                                    art.label(language),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: _isSelected(art)
                                              ? AppColors.accent
                                              : null,
                                        ),
                                  ),
                                  if (art.generic) ...[
                                    const SizedBox(
                                      height: AppDimensions.spaceXs,
                                    ),
                                    Text(
                                      l.library_categoryBadge,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                  if (_isSelected(art))
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.accent,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text(
            l.library_artNote,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
