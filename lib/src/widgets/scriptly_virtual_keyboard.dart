import 'package:flutter/material.dart';

/// An in-app on-screen virtual keyboard widget supporting phonetic typing,
/// customizable layouts, and direct binding to [TextEditingController].
class ScriptlyVirtualKeyboard extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onKeyPressed;
  final VoidCallback? onBackspace;
  final VoidCallback? onClear;
  final VoidCallback? onSubmit;
  final Color? keyBackgroundColor;
  final Color? keyTextColor;
  final double keyHeight;
  final double keySpacing;

  const ScriptlyVirtualKeyboard({
    super.key,
    this.controller,
    this.onKeyPressed,
    this.onBackspace,
    this.onClear,
    this.onSubmit,
    this.keyBackgroundColor,
    this.keyTextColor,
    this.keyHeight = 44.0,
    this.keySpacing = 6.0,
  });

  static const List<List<String>> _standardRows = [
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  ];

  void _handleKey(String char) {
    if (controller != null) {
      final text = controller!.text;
      final sel = controller!.selection;
      if (sel.isValid && sel.start >= 0) {
        final newText = text.replaceRange(sel.start, sel.end, char);
        controller!.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: sel.start + char.length),
        );
      } else {
        controller!.text = text + char;
      }
    }
    onKeyPressed?.call(char);
  }

  void _handleBackspace() {
    if (controller != null) {
      final text = controller!.text;
      final sel = controller!.selection;
      if (sel.isValid && sel.start > 0) {
        final start = sel.start == sel.end ? sel.start - 1 : sel.start;
        final newText = text.replaceRange(start, sel.end, '');
        controller!.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: start),
        );
      } else if (text.isNotEmpty) {
        controller!.text = text.substring(0, text.length - 1);
      }
    }
    onBackspace?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bg = keyBackgroundColor ?? colorScheme.surfaceContainerHighest;
    final fg = keyTextColor ?? colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in _standardRows) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final key in row)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(keySpacing / 2),
                      child: _buildKeyButton(key, bg, fg),
                    ),
                  ),
              ],
            ),
            SizedBox(height: keySpacing),
          ],
          // Bottom action row: Clear, Space, Backspace, Submit
          Row(
            children: [
              _buildActionButton(
                icon: Icons.clear_all_rounded,
                tooltip: 'Clear',
                color: colorScheme.errorContainer,
                iconColor: colorScheme.onErrorContainer,
                onTap: () {
                  controller?.clear();
                  onClear?.call();
                },
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: keySpacing / 2),
                  child: InkWell(
                    onTap: () => _handleKey(' '),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: keyHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Space',
                        style: TextStyle(
                          color: fg,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildActionButton(
                icon: Icons.backspace_rounded,
                tooltip: 'Backspace',
                color: bg,
                iconColor: fg,
                onTap: _handleBackspace,
              ),
              if (onSubmit != null) ...[
                SizedBox(width: keySpacing / 2),
                _buildActionButton(
                  icon: Icons.check_circle_rounded,
                  tooltip: 'Submit',
                  color: colorScheme.primary,
                  iconColor: colorScheme.onPrimary,
                  onTap: onSubmit!,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String char, Color bg, Color fg) {
    return InkWell(
      onTap: () => _handleKey(char),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: keyHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          char.toUpperCase(),
          style: TextStyle(
            color: fg,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: keySpacing / 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 52,
          height: keyHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }
}
