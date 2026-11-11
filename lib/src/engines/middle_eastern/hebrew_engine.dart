import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Bidirectional transliteration between Latin (Roman Hebrew) and Hebrew square script.
class HebrewEngine implements TransliteratorEngine {
  @override
  String get id => 'hebrew-script-engine';

  @override
  String get scheme => 'roman-to-hebrew';

  @override
  String get version => '0.2.0';

  static const Map<String, String> commonWords = {
    'shalom': '\u05E9\u05DC\u05D5\u05DD',
    'toda': '\u05EA\u05D5\u05D3\u05D4',
    'boker tov': '\u05D1\u05D5\u05E7\u05E8 \u05D8\u05D5\u05D1',
    'ken': '\u05DB\u05DF',
    'lo': '\u05DC\u05D0',
    'yisrael': '\u05D9\u05E9\u05E8\u05D0\u05DC',
    'israel': '\u05D9\u05E9\u05E8\u05D0\u05DC',
    'sababa': '\u05E1\u05D1\u05D1\u05D4',
  };

  static const Map<String, String> charMap = {
    'sh': '\u05E9',
    'ch': '\u05D7',
    'ts': '\u05E6',
    'a': '\u05D0',
    'b': '\u05D1',
    'v': '\u05D1',
    'g': '\u05D2',
    'd': '\u05D3',
    'h': '\u05D4',
    'w': '\u05D5',
    'u': '\u05D5',
    'o': '\u05D5',
    'z': '\u05D6',
    't': '\u05D8',
    'y': '\u05D9',
    'i': '\u05D9',
    'k': '\u05DB',
    'l': '\u05DC',
    'm': '\u05DE',
    'n': '\u05E0',
    's': '\u05E1',
    'p': '\u05E4',
    'f': '\u05E4',
    'q': '\u05E7',
    'r': '\u05E8',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedScript;
    final t = to.normalizedScript;
    return (f == 'Latn' && t == 'Hebr') || (f == 'Hebr' && t == 'Latn');
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatnToHebr = request.from.normalizedScript == 'Latn';
    final output = isLatnToHebr ? _toHebrew(request.text) : _toLatin(request.text);

    return ConversionResult(
      text: output,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: isLatnToHebr ? 'roman-to-hebrew' : 'hebrew-to-roman',
    );
  }

  String _toHebrew(String input) {
    final lower = input.toLowerCase().trim();
    if (commonWords.containsKey(lower)) {
      return commonWords[lower]!;
    }

    final buffer = StringBuffer();
    final len = input.length;
    var index = 0;

    while (index < len) {
      final codeUnit = input.codeUnitAt(index);
      if (codeUnit == 0x20 || codeUnit == 0x09 || codeUnit == 0x0A || (codeUnit >= 0x21 && codeUnit <= 0x2F)) {
        buffer.writeCharCode(codeUnit);
        index++;
        continue;
      }

      final match = _matchLongest(input, index);
      if (match != null) {
        buffer.write(match.value);
        index += match.key.length;
      } else {
        buffer.write(input[index]);
        index++;
      }
    }
    return buffer.toString();
  }

  String _toLatin(String input) {
    for (final entry in commonWords.entries) {
      if (input.trim() == entry.value) {
        final k = entry.key;
        return k[0].toUpperCase() + k.substring(1);
      }
    }

    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= 0x05D0 && rune <= 0x05EA) {
        buffer.write(_hebrewToLatinChar(rune));
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  String _hebrewToLatinChar(int rune) {
    switch (rune) {
      case 0x05D0: return 'a';
      case 0x05D1: return 'b';
      case 0x05D2: return 'g';
      case 0x05D3: return 'd';
      case 0x05D4: return 'h';
      case 0x05D5: return 'v';
      case 0x05D6: return 'z';
      case 0x05D7: return 'ch';
      case 0x05D8: return 't';
      case 0x05D9: return 'y';
      case 0x05DA:
      case 0x05DB: return 'k';
      case 0x05DC: return 'l';
      case 0x05DD:
      case 0x05DE: return 'm';
      case 0x05DF:
      case 0x05E0: return 'n';
      case 0x05E1: return 's';
      case 0x05E2: return 'a';
      case 0x05E3:
      case 0x05E4: return 'p';
      case 0x05E5:
      case 0x05E6: return 'ts';
      case 0x05E7: return 'q';
      case 0x05E8: return 'r';
      case 0x05E9: return 'sh';
      case 0x05EA: return 't';
      default: return String.fromCharCode(rune);
    }
  }

  MapEntry<String, String>? _matchLongest(String text, int start) {
    final rem = text.substring(start).toLowerCase();
    for (var len = 2; len >= 1; len--) {
      if (rem.length >= len) {
        final sub = rem.substring(0, len);
        if (charMap.containsKey(sub)) return MapEntry(sub, charMap[sub]!);
      }
    }
    return null;
  }
}
