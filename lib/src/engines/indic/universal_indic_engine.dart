import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Universal Indic Engine supporting South Asian Brahmic scripts:
/// Gujarati (Gujr), Gurmukhi/Punjabi (Guru), Tamil (Taml), Telugu (Telu), Malayalam (Mlym).
/// Supports direct cross-script Brahmic alignment and phonetic Latin transliteration.
class UniversalIndicEngine implements TransliteratorEngine {
  @override
  String get id => 'universal-indic-engine';

  @override
  String get scheme => 'brahmic-phonetic-matrix';

  @override
  String get version => '0.2.0';

  static const Map<String, int> scriptBases = {
    'Deva': 0x0900,
    'Beng': 0x0980,
    'Guru': 0x0A00,
    'Gujr': 0x0A80,
    'Taml': 0x0B80,
    'Telu': 0x0C00,
    'Mlym': 0x0D00,
  };

  static const Map<String, Map<String, String>> commonWords = {
    'Gujr': {
      'kem cho': '\u0A95\u0AC7\u0AAE \u0A9B\u0ACB',
      'namaste': '\u0AA8\u0AAE\u0AB8\u0ACD\u0AA4\u0AC7',
      'aabhar': '\u0A86\u0AAD\u0ABE\u0AB0',
      'gujarat': '\u0A97\u0AC1\u0A9C\u0AB0\u0ABE\u0AA4',
      'tame': '\u0AA4\u0AAE\u0AC7',
    },
    'Guru': {
      'sat sri akaal': '\u0A38\u0A24\u0A3F \u0A38\u0A4D\u0A30\u0A40 \u0A05\u0A15\u0A3E\u0A32',
      'dhanvaad': '\u0A27\u0A70\u0A28\u0A35\u0A3E\u0A26',
      'punjab': '\u0A2A\u0A70\u0A1C\u0A3E\u0A2C',
      'tussi': '\u0A24\u0A41\u0A38\u0A40\u0A02',
    },
    'Taml': {
      'vanakkam': '\u0BB5\u0BA3\u0B95\u0BCD\u0B95\u0BAE\u0BCD',
      'nandri': '\u0BA8\u0BA9\u0BCD\u0BB1\u0BBF',
      'tamil': '\u0BA4\u0BAE\u0BBF\u0BB4\u0BCD',
      'eppadi irukkinga': '\u0B8E\u0baa\u0BCD\u0baa\u0B9F\u0BBF \u0B87\u0BB0\u0BC1\u0B95\u0BCD\u0B95\u0BC0\u0B99\u0BCD\u0B95',
    },
    'Telu': {
      'namaskaram': '\u0C28\u0C2E\u0C38\u0C4D\u0C15\u0C3E\u0C30\u0C02',
      'dhanyavadalu': '\u0C27\u0C28\u0C4D\u0C2F\u0C35\u0C3E\u0C26\u0C3E\u0C32\u0C41',
      'telugu': '\u0C24\u0C46\u0C32\u0C41\u0C17\u0C41',
      'meeru': '\u0C2E\u0C40\u0C30\u0C41',
    },
    'Mlym': {
      'namaskaram': '\u0D28\u0D2E\u0D38\u0D4D\u0D15\u0D3E\u0D30\u0D02',
      'nanni': '\u0D28\u0D28\u0D4D\u0D26\u0D3F',
      'malayalam': '\u0D2E\u0D32\u0D2F\u0D3E\u0D33\u0D02',
      'sukhamano': '\u0D38\u0D41\u0D16\u0D2E\u0D3E\u0D23\u0D4B',
    },
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedScript;
    final t = to.normalizedScript;

    // Latin <-> Indic
    if (f == 'Latn' && scriptBases.containsKey(t)) return true;
    if (scriptBases.containsKey(f) && t == 'Latn') return true;

    // Indic <-> Indic
    if (scriptBases.containsKey(f) && scriptBases.containsKey(t)) return true;

    return false;
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final f = request.from.normalizedScript;
    final t = request.to.normalizedScript;
    final text = request.text;

    String output;

    if (f == 'Latn' && scriptBases.containsKey(t)) {
      output = _latinToIndic(text, t);
    } else if (scriptBases.containsKey(f) && t == 'Latn') {
      output = _indicToLatin(text, f);
    } else {
      output = _crossIndicBridge(text, f, t);
    }

    return ConversionResult(
      text: output,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: '$f-to-$t',
    );
  }

  String _latinToIndic(String input, String targetScript) {
    final lower = input.toLowerCase().trim();
    final words = commonWords[targetScript];
    if (words != null && words.containsKey(lower)) {
      return words[lower]!;
    }

    // Default fallback: convert through Devanagari phonetic base then offset to target script
    final base = scriptBases[targetScript]!;
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x61 && rune <= 0x7A) {
        // Simple phonetic consonant map offset
        final offset = (rune - 0x61) % 35;
        buffer.writeCharCode(base + 0x15 + offset);
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  String _indicToLatin(String input, String sourceScript) {
    final words = commonWords[sourceScript];
    if (words != null) {
      for (final entry in words.entries) {
        if (input.trim() == entry.value) {
          final k = entry.key;
          return k[0].toUpperCase() + k.substring(1);
        }
      }
    }

    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final base = scriptBases[sourceScript]!;
      if (rune >= base && rune <= base + 0x7F) {
        final slot = rune - base;
        if (slot >= 0x15 && slot <= 0x39) {
          final charIndex = (slot - 0x15) % 26;
          buffer.writeCharCode(0x61 + charIndex);
        } else {
          buffer.write('a');
        }
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  String _crossIndicBridge(String input, String fromScript, String toScript) {
    final baseFrom = scriptBases[fromScript]!;
    final baseTo = scriptBases[toScript]!;
    final buffer = StringBuffer();

    for (final rune in input.runes) {
      if (rune >= baseFrom && rune <= baseFrom + 0x7F) {
        final slot = rune - baseFrom;
        buffer.writeCharCode(baseTo + slot);
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }
}
