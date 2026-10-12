import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/widgets.dart';
import '../data/food_catalog.dart';

/// Searchable art menu, including broad categories for off-menu dishes.
class FoodLibraryScreen extends StatefulWidget {
  const FoodLibraryScreen({super.key, this.selectedId});
  final String? selectedId;
  @override
  State<FoodLibraryScreen> createState() => _FoodLibraryScreenState();
}

class _FoodLibraryScreenState extends State<FoodLibraryScreen> {
  String _query = '', _group = 'all';
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

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
      'categories': l.library_categories,
    };
    final matches = foodCatalog
        .where(
          (art) =>
              art.matches(_query) && (_group == 'all' || art.group == _group),
        )
        .toList();
    return DinerScaffold(
      title: l.library_title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DinerEntrance(child: DinerHeading(l.library_hint)),
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
            Text(l.library_genericHint),
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
                  ? foodCatalog.where((a) => a.generic)
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
                        selected: art.id == widget.selectedId,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            key: ValueKey('food-art-${art.id}'),
                            borderRadius: AppDimensions.borderRadiusMd,
                            onTap: () => Navigator.pop(context, art),
                            child: DinerTicket(
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
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
                                  if (art.id == widget.selectedId)
                                    const Icon(Icons.check_circle_rounded),
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
