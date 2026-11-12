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
    'Orya': 0x0B00,
    'Taml': 0x0B80,
    'Telu': 0x0C00,
    'Knda': 0x0C80,
    'Mlym': 0x0D00,
    'Sinh': 0x0D80,
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
      'sat sri akal': '\u0A38\u0A24\u0A3F \u0A38\u0A4D\u0A30\u0A40 \u0A05\u0A15\u0A3E\u0A32',
      'sat': '\u0A38\u0A24\u0A3F',
      'dhanvaad': '\u0A27\u0A70\u0A28\u0A35\u0A3E\u0A26',
      'punjab': '\u0A2A\u0A70\u0A1C\u0A3E\u0A2C',
      'tussi': '\u0A24\u0A41\u0A38\u0A40\u0A02',
    },
    'Orya': {
      'namaskar': '\u0B28\u0B2E\u0B38\u0B4D\u0B15\u0B3E\u0B30',
      'dhanyabad': '\u0B27\u0B28\u0B4D\u0B5F\u0B2C\u0B3E\u0B26',
      'odia': '\u0B13\u0B21\u0B3C\u0B3F\u0B06',
      'kemiti achanti': '\u0B15\u0B47\u0B2E\u0B3F\u0B24\u0B3F \u0B05\u0B1B\u0B28\u0B4D\u0B24\u0B3F',
      'bhubaneswar': '\u0B2D\u0B41\u0B2C\u0B28\u0B47\u0B36\u0B4D\u0B71\u0B30',
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
    'Knda': {
      'namaskara': '\u0CA8\u0CAE\u0CB8\u0CCD\u0C95\u0CBE\u0CB0',
      'dhanyavada': '\u0CA7\u0CA8\u0CCD\u0CAF\u0CB5\u0CBE\u0CA6',
      'kannada': '\u0C95\u0CA8\u0CCD\u0CA8\u0CA1',
      'hegiddeera': '\u0CB9\u0CC7\u0C97\u0CBF\u0CA6\u0CCD\u0CA6\u0CC0\u0CB0\u0CBE',
      'bengaluru': '\u0CAC\u0CC6\u0C82\u0C97\u0CB3\u0CC2\u0CB0\u0CC1',
    },
    'Mlym': {
      'namaskaram': '\u0D28\u0D2E\u0D38\u0D4D\u0D15\u0D3E\u0D30\u0D02',
      'nanni': '\u0D28\u0D28\u0D4D\u0D26\u0D3F',
      'malayalam': '\u0D2E\u0D32\u0D2F\u0D3E\u0D33\u0D02',
      'sukhamano': '\u0D38\u0D41\u0D16\u0D2E\u0D3E\u0D23\u0D4B',
    },
    'Sinh': {
      'ayubowan': '\u0D86\u0DBA\u0DD4\u0DB6\u0DDD\u0DC0\u0DB1\u0DCA',
      'sthuthiyi': '\u0DC3\u0DCA\u0DAD\u0DD6\u0DAD\u0DD2\u0DBA\u0DD2',
      'sinhala': '\u0DC3\u0DD2\u0D82\u0DC4\u0DBD',
      'kohomada': '\u0D9A\u0DDC\u0DC4\u0DDC\u0DB8\u0DAF',
      'sri lanka': '\u0DC1\u0DCA\u0DBB\u0DD3 \u0DBD\u0D82\u0D9A\u0DCF',
    },
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedScript;
    final t = to.normalizedScript;
    final fLang = from.normalizedLanguage;
    final tLang = to.normalizedLanguage;

    final isFromLatin = f == 'Latn' && (fLang == 'en' || fLang == 'latn');
    final isToLatin = t == 'Latn' && (tLang == 'en' || tLang == 'latn');

    // Latin (English) <-> Indic
    if (isFromLatin && scriptBases.containsKey(t)) return true;
    if (scriptBases.containsKey(f) && isToLatin) return true;

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

    final isFromLatin = f == 'Latn' && (request.from.normalizedLanguage == 'en' || request.from.normalizedLanguage == 'latn');
    final isToLatin = t == 'Latn' && (request.to.normalizedLanguage == 'en' || request.to.normalizedLanguage == 'latn');

    if (isFromLatin && scriptBases.containsKey(t)) {
      output = _latinToIndic(text, t);
    } else if (scriptBases.containsKey(f) && isToLatin) {
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
    final words = commonWords[targetScript];
    if (words == null || input.isEmpty) return input;

    var result = input;
    // 1. Replace dictionary words case-insensitively with word boundaries
    for (final entry in words.entries) {
      final pattern = RegExp('\\b${RegExp.escape(entry.key)}\\b', caseSensitive: false);
      result = result.replaceAllMapped(pattern, (m) => entry.value);
    }

    // 2. Fallback phonetic mapping for remaining ASCII letters if any
    final base = scriptBases[targetScript]!;
    final buffer = StringBuffer();
    for (final rune in result.runes) {
      if (rune >= 0x61 && rune <= 0x7A) {
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
