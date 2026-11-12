import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern text field widget that displays inline ghost-text predictions
/// ahead of the cursor (GitHub Copilot style) that can be accepted with Tab, Right Arrow, or tap.
class ScriptlyAutocompleteTextField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final Future<String?> Function(String currentText)? predictionProvider;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextStyle? ghostStyle;

  const ScriptlyAutocompleteTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.predictionProvider,
    this.decoration,
    this.style,
    this.ghostStyle,
  });

  @override
  State<ScriptlyAutocompleteTextField> createState() =>
      _ScriptlyAutocompleteTextFieldState();
}

class _ScriptlyAutocompleteTextFieldState
    extends State<ScriptlyAutocompleteTextField> {
  String _ghostText = '';
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() async {
    final text = widget.controller.text;
    if (text.isEmpty || widget.predictionProvider == null) {
      if (_ghostText.isNotEmpty) setState(() => _ghostText = '');
      return;
    }

    final prediction = await widget.predictionProvider!(text);
    if (!mounted) return;

    if (prediction != null &&
        prediction.startsWith(text) &&
        prediction.length > text.length) {
      setState(() {
        _ghostText = prediction.substring(text.length);
      });
    } else {
      if (_ghostText.isNotEmpty) setState(() => _ghostText = '');
    }
  }

  void _acceptGhost() {
    if (_ghostText.isNotEmpty) {
      final newText = widget.controller.text + _ghostText;
      widget.controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      setState(() => _ghostText = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle =
        widget.style ?? theme.textTheme.bodyLarge ?? const TextStyle();
    final defaultGhostStyle =
        widget.ghostStyle ??
        defaultStyle.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.tab): _acceptGhost,
        const SingleActivator(LogicalKeyboardKey.arrowRight): () {
          final sel = widget.controller.selection;
          if (sel.isCollapsed &&
              sel.baseOffset == widget.controller.text.length) {
            _acceptGhost();
          }
        },
      },
      child: Focus(
        focusNode: _focusNode,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            TextField(
              controller: widget.controller,
              style: defaultStyle,
              decoration: widget.decoration ?? const InputDecoration(),
              onChanged: widget.onChanged,
            ),
            if (_ghostText.isNotEmpty)
              Positioned(
                right: 12,
                child: GestureDetector(
                  onTap: _acceptGhost,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_ghostText, style: defaultGhostStyle),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_tab_rounded,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
