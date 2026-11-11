import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Direct cross-script transliteration engine between Indic writing systems
/// (specifically Devanagari and Bengali) using shared Brahmic phonetic mapping.
class IndicBridgeEngine implements TransliteratorEngine {
  @override
  String get id => 'indic-bridge-engine';

  @override
  String get scheme => 'brahmic-unicode-alignment';

  @override
  String get version => '0.1.0';

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedScript;
    final t = to.normalizedScript;
    return (f == 'Deva' && t == 'Beng') || (f == 'Beng' && t == 'Deva');
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final fromScript = request.from.normalizedScript;
    final text = request.text;

    final converted = fromScript == 'Deva'
        ? _devaToBeng(text)
        : _bengToDeva(text);

    return ConversionResult(
      text: converted,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }

  String _devaToBeng(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      if (rune >= 0x0900 && rune <= 0x097F) {
        // Special case mappings where Bengali glyphs differ
        if (rune == 0x0935) {
          // Devanagari Va -> Bengali Ba (0x09AC)
          buffer.writeCharCode(0x09AC);
        } else if (rune == 0x090A) {
          // Devanagari Oo -> Bengali Oo (0x098A)
          buffer.writeCharCode(0x098A);
        } else {
          // Standard Brahmic block offset (+0x80)
          final bengRune = rune + 0x80;
          buffer.writeCharCode(bengRune);
        }
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  String _bengToDeva(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      if (rune >= 0x0980 && rune <= 0x09FF) {
        final devaRune = rune - 0x80;
        buffer.writeCharCode(devaRune);
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }
}
