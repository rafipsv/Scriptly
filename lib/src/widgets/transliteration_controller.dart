import 'package:flutter/widgets.dart';

import '../core/conversion_options.dart';
import '../core/language_script.dart';
import '../core/transliterator.dart';

/// A [TextEditingController] that automatically transliterates text in real-time.
class TransliterationTextEditingController extends TextEditingController {
  final LanguageScript from;
  final LanguageScript to;
  final Transliterator _transliterator;
  final ConversionOptions options;
  bool isEnabled;
  bool _isConverting = false;
  bool _wasComposing = false;
  final List<TextEditingValue> _history = [];
  int _historyIndex = -1;

  TransliterationTextEditingController({
    super.text,
    required this.from,
    required this.to,
    Transliterator? transliterator,
    this.options = ConversionOptions.standard,
    this.isEnabled = true,
  }) : _transliterator = transliterator ?? Transliterator() {
    _recordHistory(value);
  }

  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;

  void undo() => canUndo ? super.value = _history[--_historyIndex] : null;
  void redo() => canRedo ? super.value = _history[++_historyIndex] : null;

  void _recordHistory(TextEditingValue val) {
    if (_historyIndex >= 0 && _history[_historyIndex].text == val.text) return;
    if (_historyIndex < _history.length - 1)
      _history.removeRange(_historyIndex + 1, _history.length);
    _history.add(val);
    if (_history.length > 25) _history.removeAt(0);
    _historyIndex = _history.length - 1;
  }

  @override
  set value(TextEditingValue newValue) {
    if (!isEnabled || _isConverting) {
      super.value = newValue;
      _recordHistory(newValue);
      return;
    }

    if (newValue.isComposingRangeValid) {
      _wasComposing = true;
      super.value = newValue;
      _recordHistory(newValue);
      return;
    }

    final justFinishedComposing = _wasComposing;
    _wasComposing = false;

    if (!justFinishedComposing && newValue.text == text) {
      super.value = newValue;
      _recordHistory(newValue);
      return;
    }

    _isConverting = true;
    try {
      final converted = _transliterator
          .convert(newValue.text, from: from, to: to, options: options)
          .text;
      final diff = converted.length - newValue.text.length;
      final newCursor = (newValue.selection.baseOffset + diff).clamp(
        0,
        converted.length,
      );

      final result = TextEditingValue(
        text: converted,
        selection: TextSelection.collapsed(offset: newCursor),
        composing: TextRange.empty,
      );
      super.value = result;
      _recordHistory(result);
    } catch (_) {
      super.value = newValue;
      _recordHistory(newValue);
    } finally {
      _isConverting = false;
    }
  }

  void toggleEnabled() => isEnabled = !isEnabled;
}
