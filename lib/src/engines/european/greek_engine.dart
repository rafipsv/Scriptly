import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Bidirectional transliteration between Latin (Greeklish) and Greek alphabet (ISO 843 standard).
class GreekEngine implements TransliteratorEngine {
  @override
  String get id => 'greek-alphabet-engine';

  @override
  String get scheme => 'iso-843-greek';

  @override
  String get version => '0.2.0';

  static const Map<String, String> commonWords = {
    'kalimera': '\u03BA\u03B1\u03BB\u03B7\u03BC\u03AD\u03C1\u03B1',
    'efcharisto': '\u03B5\u03C5\u03C7\u03B1\u03C1\u03B9\u03C3\u03C4\u03CE',
    'geia sou': '\u03B3\u03B5\u03B9\u03B1 \u03C3\u03BF\u03C5',
    'ellada': '\u03B5\u03BB\u03BB\u03AC\u03B4\u03B1',
    'nai': '\u03BD\u03B1\u03B9',
    'ochi': '\u03CC\u03C7\u03B9',
  };

  static const Map<String, String> charMap = {
    'th': '\u03B8',
    'ch': '\u03C7',
    'ps': '\u03C8',
    'ks': '\u03BE',
    'a': '\u03B1',
    'b': '\u03B2',
    'g': '\u03B3',
    'd': '\u03B4',
    'e': '\u03B5',
    'z': '\u03B6',
    'i': '\u03B9',
    'k': '\u03BA',
    'l': '\u03BB',
    'm': '\u03BC',
    'n': '\u03BD',
    'x': '\u03BE',
    'o': '\u03BF',
    'p': '\u03C0',
    'r': '\u03C1',
    's': '\u03C3',
    't': '\u03C4',
    'u': '\u03C5',
    'y': '\u03C5',
    'f': '\u03C6',
    'w': '\u03C9',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedScript;
    final t = to.normalizedScript;
    return (f == 'Latn' && t == 'Grek') || (f == 'Grek' && t == 'Latn');
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatnToGrek = request.from.normalizedScript == 'Latn';
    final output = isLatnToGrek
        ? _toGreek(request.text)
        : _toLatin(request.text);

    return ConversionResult(
      text: output,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: isLatnToGrek ? 'greeklish-to-greek' : 'greek-to-latin',
    );
  }

  String _toGreek(String input) {
    final lower = input.toLowerCase().trim();
    if (commonWords.containsKey(lower)) {
      return commonWords[lower]!;
    }

    final buffer = StringBuffer();
    final len = input.length;
    var index = 0;

    while (index < len) {
      final codeUnit = input.codeUnitAt(index);
      if (codeUnit == 0x20 ||
          codeUnit == 0x09 ||
          codeUnit == 0x0A ||
          (codeUnit >= 0x21 && codeUnit <= 0x2F)) {
        buffer.writeCharCode(codeUnit);
        index++;
        continue;
      }

      // Check if common word matches at this index as a word boundary
      String? matchedWordKey;
      for (final key in commonWords.keys) {
        if (input.toLowerCase().startsWith(key, index)) {
          final afterIndex = index + key.length;
          final isAtEnd = afterIndex == len;
          final isNextNonWord =
              isAtEnd || !RegExp(r'[a-zA-Z]').hasMatch(input[afterIndex]);
          if (isNextNonWord) {
            matchedWordKey = key;
            break;
          }
        }
      }
      if (matchedWordKey != null) {
        buffer.write(commonWords[matchedWordKey]!);
        index += matchedWordKey.length;
        continue;
      }

      final match = _matchLongest(input, index);
      if (match != null) {
        // Special case: sigma at end of word is final sigma (\u03C2)
        if (match.value == '\u03C3' &&
            (index + 1 == len || input.codeUnitAt(index + 1) == 0x20)) {
          buffer.write('\u03C2');
        } else {
          buffer.write(match.value);
        }
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
      buffer.write(_greekToLatinChar(rune));
    }
    return buffer.toString();
  }

  String _greekToLatinChar(int rune) {
    switch (rune) {
      case 0x03B1:
      case 0x03AC:
        return 'a';
      case 0x03B2:
        return 'v';
      case 0x03B3:
        return 'g';
      case 0x03B4:
        return 'd';
      case 0x03B5:
      case 0x03AD:
        return 'e';
      case 0x03B6:
        return 'z';
      case 0x03B7:
      case 0x03AE:
        return 'i';
      case 0x03B8:
        return 'th';
      case 0x03B9:
      case 0x03AF:
        return 'i';
      case 0x03BA:
        return 'k';
      case 0x03BB:
        return 'l';
      case 0x03BC:
        return 'm';
      case 0x03BD:
        return 'n';
      case 0x03BE:
        return 'x';
      case 0x03BF:
      case 0x03CC:
        return 'o';
      case 0x03C0:
        return 'p';
      case 0x03C1:
        return 'r';
      case 0x03C3:
      case 0x03C2:
        return 's';
      case 0x03C4:
        return 't';
      case 0x03C5:
      case 0x03CD:
        return 'y';
      case 0x03C6:
        return 'f';
      case 0x03C7:
        return 'ch';
      case 0x03C8:
        return 'ps';
      case 0x03C9:
      case 0x03CE:
        return 'o';
      default:
        return String.fromCharCode(rune);
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
