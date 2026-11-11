import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scriptly/scriptly.dart';

import '../../core/constants/app_constants.dart';
import '../bloc/transliterator/transliterator_bloc.dart';
import '../bloc/transliterator/transliterator_event.dart';
import '../bloc/transliterator/transliterator_state.dart';

/// Highly polished, modern language selection bar with custom styled dropdowns.
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
                        if (lang != null) {
                          context.read<TransliteratorBloc>().add(
                            TransliteratorSourceChanged(lang),
                          );
                        }
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
                        if (lang != null) {
                          context.read<TransliteratorBloc>().add(
                            TransliteratorTargetChanged(lang),
                          );
                        }
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
                        if (lang != null) {
                          context.read<TransliteratorBloc>().add(
                            TransliteratorSourceChanged(lang),
                          );
                        }
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
                        if (lang != null) {
                          context.read<TransliteratorBloc>().add(
                            TransliteratorTargetChanged(lang),
                          );
                        }
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
    required ValueChanged<LanguageScript?> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<LanguageScript>(
              value: value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(16),
              dropdownColor: colorScheme.surfaceContainerHigh,
              elevation: 4,
              menuMaxHeight: 400,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
              selectedItemBuilder: (context) {
                return AppConstants.supportedLanguages.map<Widget>((lang) {
                  final name = lang['name'] as String;
                  final code = lang['code'] as String;
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
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
                      const SizedBox(width: 8),
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
                    ],
                  );
                }).toList();
              },
              items: AppConstants.supportedLanguages.map((lang) {
                final script = lang['script'] as LanguageScript;
                final name = lang['name'] as String;
                final code = lang['code'] as String;
                final category = lang['category'] as String? ?? 'General';
                final isSelected = script == value;

                return DropdownMenuItem<LanguageScript>(
                  value: script,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
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
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
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
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme.outline,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
