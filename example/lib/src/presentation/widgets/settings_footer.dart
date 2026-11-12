import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transliterator/transliterator_bloc.dart';
import '../bloc/transliterator/transliterator_event.dart';
import '../bloc/transliterator/transliterator_state.dart';

/// Bottom settings card providing client-side offline info and enterprise control toggles.
class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.offline_bolt_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '100% Client-Side, Offline & Private (No APIs, No Cloud Tracking)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            BlocBuilder<TransliteratorBloc, TransliteratorState>(
              builder: (context, state) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildToggle(
                      label: 'Convert Digits',
                      tooltip:
                          'Convert ASCII digits into target script numbers',
                      value: state.convertDigits,
                      onChanged: (val) => context
                          .read<TransliteratorBloc>()
                          .add(TransliteratorDigitsToggled(val)),
                      colorScheme: colorScheme,
                    ),
                    _buildToggle(
                      label: 'Shield PII',
                      tooltip: 'Mask and preserve credit cards, emails, phones, and OTPs',
                      value: state.shieldPii,
                      onChanged: (val) => context
                          .read<TransliteratorBloc>()
                          .add(TransliteratorPiiToggled(val)),
                      colorScheme: colorScheme,
                    ),
                    _buildToggle(
                      label: 'Smart Punctuation',
                      tooltip: 'Auto-convert . to Dari । and ? to Arabic ؟',
                      value: state.harmonizePunctuation,
                      onChanged: (val) => context
                          .read<TransliteratorBloc>()
                          .add(TransliteratorPunctuationToggled(val)),
                      colorScheme: colorScheme,
                    ),
                    _buildToggle(
                      label: 'Markdown Mode',
                      tooltip: 'Preserve code blocks, URLs, and HTML syntax untouched',
                      value: state.markdownMode,
                      onChanged: (val) => context
                          .read<TransliteratorBloc>()
                          .add(TransliteratorMarkdownToggled(val)),
                      colorScheme: colorScheme,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({
    required String label,
    required String tooltip,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ColorScheme colorScheme,
  }) {
    return Tooltip(
      message: tooltip,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 6),
          Switch(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
