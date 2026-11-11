import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transliterator/transliterator_bloc.dart';
import '../bloc/transliterator/transliterator_state.dart';

/// Card presenting the transliterated result with scheme details and copy action.
class TargetCard extends StatelessWidget {
  const TargetCard({super.key});

  void _copy(BuildContext context, String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transliterated text copied to clipboard!'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<TransliteratorBloc, TransliteratorState>(
      buildWhen: (prev, curr) =>
          prev.outputText != curr.outputText ||
          prev.activeScheme != curr.activeScheme,
      builder: (context, state) {
        return Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TRANSLITERATED TEXT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: colorScheme.primary,
                      ),
                    ),
                    if (state.activeScheme.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          state.activeScheme,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 144),
                  child: SelectableText(
                    state.outputText.isEmpty
                        ? 'Transliterated text will appear here...'
                        : state.outputText,
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.5,
                      color: state.outputText.isEmpty
                          ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.outputText.length} characters',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copy Transliterated Text',
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      onPressed: () => _copy(context, state.outputText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
