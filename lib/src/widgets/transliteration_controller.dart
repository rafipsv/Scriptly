import 'package:flutter/widgets.dart';

import '../core/conversion_options.dart';
import '../core/language_script.dart';
import '../core/transliterator.dart';

/// A [TextEditingController] that automatically transliterates text in real-time.
class TransliterationTextEditingController extends TextEditingController {
  /// Source language/script.
  final LanguageScript from;

  /// Target language/script.
  final LanguageScript to;

  /// Underlying transliteration engine.
  final Transliterator _transliterator;

  /// Conversion options.
  final ConversionOptions options;

  /// Toggle whether live transliteration is active.
  bool isEnabled;

  bool _isConverting = false;

  /// Creates a [TransliterationTextEditingController].
  TransliterationTextEditingController({
    super.text,
    required this.from,
    required this.to,
    Transliterator? transliterator,
    this.options = ConversionOptions.standard,
    this.isEnabled = true,
  }) : _transliterator = transliterator ?? Transliterator();

  @override
  set value(TextEditingValue newValue) {
    if (!isEnabled || _isConverting || newValue.text == text) {
      super.value = newValue;
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

      super.value = TextEditingValue(
        text: converted,
        selection: TextSelection.collapsed(offset: newCursor),
        composing: TextRange.empty,
      );
    } catch (_) {
      super.value = newValue;
    } finally {
      _isConverting = false;
    }
  }

  /// Toggles whether live transliteration is active.
  void toggleEnabled() {
    isEnabled = !isEnabled;
  }
}
