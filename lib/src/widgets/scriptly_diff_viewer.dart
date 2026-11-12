import 'package:flutter/material.dart';

/// A visual diff widget that displays side-by-side or inline comparisons between
/// original Romanized text and the transliterated Native output with token-level highlights.
class ScriptlyDiffViewer extends StatelessWidget {
  final String sourceText;
  final String targetText;
  final String? sourceLabel;
  final String? targetLabel;
  final bool isInline;

  const ScriptlyDiffViewer({
    super.key,
    required this.sourceText,
    required this.targetText,
    this.sourceLabel = 'SOURCE',
    this.targetLabel = 'TRANSLITERATED',
    this.isInline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isInline) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildInlineTokens(colorScheme),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 450;
        final children = [
          Expanded(
            flex: isNarrow ? 0 : 1,
            child: _buildCard(
              title: sourceLabel ?? 'SOURCE',
              text: sourceText,
              colorScheme: colorScheme,
              accentColor: colorScheme.secondary,
            ),
          ),
          if (!isNarrow)
            const SizedBox(width: 12)
          else
            const SizedBox(height: 12),
          Expanded(
            flex: isNarrow ? 0 : 1,
            child: _buildCard(
              title: targetLabel ?? 'TRANSLITERATED',
              text: targetText,
              colorScheme: colorScheme,
              accentColor: colorScheme.primary,
            ),
          ),
        ];

        return isNarrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              );
      },
    );
  }

  Widget _buildCard({
    required String title,
    required String text,
    required ColorScheme colorScheme,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            text.isEmpty ? '(Empty)' : text,
            style: TextStyle(
              fontSize: 14,
              color: text.isEmpty ? colorScheme.outline : colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInlineTokens(ColorScheme colorScheme) {
    final sWords = sourceText.split(RegExp(r'\s+'));
    final tWords = targetText.split(RegExp(r'\s+'));
    final maxLen = sWords.length > tWords.length
        ? sWords.length
        : tWords.length;

    final widgets = <Widget>[];
    for (var i = 0; i < maxLen; i++) {
      final s = i < sWords.length ? sWords[i] : '';
      final t = i < tWords.length ? tWords[i] : '';

      widgets.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                s,
                style: TextStyle(fontSize: 11, color: colorScheme.outline),
              ),
              Text(
                t,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}
