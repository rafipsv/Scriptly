import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scriptly/scriptly.dart';

import '../../core/constants/app_constants.dart';
import '../bloc/transliterator/transliterator_bloc.dart';
import '../bloc/transliterator/transliterator_event.dart';
import '../bloc/transliterator/transliterator_state.dart';

/// Highly polished, modern language selection bar with searchable selection sheets.
class LanguageSelectorBar extends StatelessWidget {
  const LanguageSelectorBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<TransliteratorBloc, TransliteratorState>(
      buildWhen: (prev, curr) =>
          prev.sourceLang != curr.sourceLang ||
          prev.targetLang != curr.targetLang,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 500;

              if (isNarrow) {
                return Column(
                  children: [
                    _buildLanguageCard(
                      context,
                      label: 'FROM (SOURCE)',
                      value: state.sourceLang,
                      onChanged: (lang) {
                        context.read<TransliteratorBloc>().add(
                          TransliteratorSourceChanged(lang),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildSwapButton(context, isVertical: true),
                    const SizedBox(height: 8),
                    _buildLanguageCard(
                      context,
                      label: 'TO (TARGET)',
                      value: state.targetLang,
                      onChanged: (lang) {
                        context.read<TransliteratorBloc>().add(
                          TransliteratorTargetChanged(lang),
                        );
                      },
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _buildLanguageCard(
                      context,
                      label: 'FROM (SOURCE)',
                      value: state.sourceLang,
                      onChanged: (lang) {
                        context.read<TransliteratorBloc>().add(
                          TransliteratorSourceChanged(lang),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildSwapButton(context, isVertical: false),
                  ),
                  Expanded(
                    child: _buildLanguageCard(
                      context,
                      label: 'TO (TARGET)',
                      value: state.targetLang,
                      onChanged: (lang) {
                        context.read<TransliteratorBloc>().add(
                          TransliteratorTargetChanged(lang),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSwapButton(BuildContext context, {required bool isVertical}) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton.filledTonal(
      tooltip: 'Swap Languages',
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.7),
        foregroundColor: colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.all(12),
      ),
      icon: Icon(
        isVertical ? Icons.swap_vert_rounded : Icons.swap_horiz_rounded,
        size: 22,
      ),
      onPressed: () => context.read<TransliteratorBloc>().add(
        const TransliteratorLanguagesSwapped(),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context, {
    required String label,
    required LanguageScript value,
    required ValueChanged<LanguageScript> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    // Find current language info
    final currentInfo = AppConstants.supportedLanguages.firstWhere(
      (lang) => lang['script'] == value,
      orElse: () => {
        'name': value.language,
        'code': value.script,
        'category': 'General',
      },
    );

    final name = currentInfo['name'] as String;
    final code = currentInfo['code'] as String;
    final category = currentInfo['category'] as String? ?? 'General';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openSearchablePicker(
          context,
          title: label,
          selected: value,
          onSelected: onChanged,
        ),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.outline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      code,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSearchablePicker(
    BuildContext context, {
    required String title,
    required LanguageScript selected,
    required ValueChanged<LanguageScript> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SearchableLanguagePickerSheet(
        title: title,
        selected: selected,
        onSelected: (script) {
          Navigator.of(ctx).pop();
          onSelected(script);
        },
      ),
    );
  }
}

class _SearchableLanguagePickerSheet extends StatefulWidget {
  final String title;
  final LanguageScript selected;
  final ValueChanged<LanguageScript> onSelected;

  const _SearchableLanguagePickerSheet({
    required this.title,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<_SearchableLanguagePickerSheet> createState() =>
      _SearchableLanguagePickerSheetState();
}

class _SearchableLanguagePickerSheetState
    extends State<_SearchableLanguagePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);

    final filtered = AppConstants.supportedLanguages.where((lang) {
      if (_query.isEmpty) return true;
      final name = (lang['name'] as String).toLowerCase();
      final code = (lang['code'] as String).toLowerCase();
      final category = (lang['category'] as String? ?? '').toLowerCase();
      return name.contains(_query) ||
          code.contains(_query) ||
          category.contains(_query);
    }).toList();

    return Container(
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.75),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: mediaQuery.viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Field
          TextField(
            controller: _searchController,
            autofocus: false,
            decoration: InputDecoration(
              hintText:
                  'Search language, script or code (e.g. Kannada, Viet)...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (val) {
              setState(() => _query = val.trim().toLowerCase());
            },
          ),
          const SizedBox(height: 12),

          // Language count chip
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${filtered.length} languages available',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Languages list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'No languages found matching "$_query"',
                        style: TextStyle(color: colorScheme.outline),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final script = item['script'] as LanguageScript;
                      final name = item['name'] as String;
                      final code = item['code'] as String;
                      final category = item['category'] as String? ?? 'General';
                      final isSelected = script == widget.selected;

                      return ListTile(
                        onTap: () => widget.onSelected(script),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            code,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          category,
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.outline,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: colorScheme.primary,
                                size: 20,
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
