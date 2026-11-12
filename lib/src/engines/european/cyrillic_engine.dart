import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Bidirectional transliteration between Latin and Russian Cyrillic (ISO 9 standard).
class CyrillicEngine implements TransliteratorEngine {
  @override
  String get id => 'cyrillic-iso9-engine';

  @override
  String get scheme => 'iso-9-cyrillic';

  @override
  String get version => '0.2.0';

  static const Map<String, String> commonWords = {
    'privet': '\u043F\u0440\u0438\u0432\u0435\u0442',
    'spasibo': '\u0441\u043F\u0430\u0441\u0438\u0431\u043E',
    'rossiya': '\u0440\u043E\u0441\u0441\u0438\u044F',
    'da': '\u0434\u0430',
    'net': '\u043D\u0435\u0442',
    'horosho': '\u0445\u043E\u0440\u043E\u0448\u043E',
    'khorosho': '\u0445\u043E\u0440\u043E\u0448\u043E',
  };

  static const Map<String, String> charMap = {
    'shch': '\u0449',
    'sh': '\u0448',
    'ch': '\u0447',
    'zh': '\u0436',
    'kh': '\u0445',
    'ts': '\u0446',
    'ya': '\u044F',
    'yu': '\u044E',
    'yo': '\u0451',
    'a': '\u0430',
    'b': '\u0431',
    'v': '\u0432',
    'g': '\u0433',
    'd': '\u0434',
    'e': '\u0435',
    'z': '\u0437',
    'i': '\u0438',
    'j': '\u0439',
    'k': '\u043A',
    'l': '\u043B',
    'm': '\u043C',
    'n': '\u043D',
    'o': '\u043E',
    'p': '\u043F',
    'r': '\u0440',
    's': '\u0441',
    't': '\u0442',
    'u': '\u0443',
    'f': '\u0444',
    'y': '\u044B',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final fLang = from.normalizedLanguage;
    final tLang = to.normalizedLanguage;
    // Exclude Ukrainian, Serbian, Bulgarian, Macedonian, Belarusian, Kazakh
    const nonRussianCyrillic = {'uk', 'sr', 'bg', 'mk', 'be', 'kk'};
    if (nonRussianCyrillic.contains(fLang) ||
        nonRussianCyrillic.contains(tLang)) {
      return false;
    }

    final f = from.normalizedScript;
    final t = to.normalizedScript;
    return (f == 'Latn' && t == 'Cyrl') || (f == 'Cyrl' && t == 'Latn');
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatnToCyrl = request.from.normalizedScript == 'Latn';
    final output = isLatnToCyrl
        ? _toCyrillic(request.text)
        : _toLatin(request.text);

    return ConversionResult(
      text: output,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: isLatnToCyrl ? 'latin-to-cyrillic' : 'cyrillic-to-latin',
    );
  }

  String _toCyrillic(String input) {
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
      buffer.write(_cyrillicToLatinChar(rune));
    }
    return buffer.toString();
  }

  String _cyrillicToLatinChar(int rune) {
    switch (rune) {
      case 0x0430:
        return 'a';
      case 0x0431:
        return 'b';
      case 0x0432:
        return 'v';
      case 0x0433:
        return 'g';
      case 0x0434:
        return 'd';
      case 0x0435:
        return 'e';
      case 0x0451:
        return 'yo';
      case 0x0436:
        return 'zh';
      case 0x0437:
        return 'z';
      case 0x0438:
        return 'i';
      case 0x0439:
        return 'j';
      case 0x043A:
        return 'k';
      case 0x043B:
        return 'l';
      case 0x043C:
        return 'm';
      case 0x043D:
        return 'n';
      case 0x043E:
        return 'o';
      case 0x043F:
        return 'p';
      case 0x0440:
        return 'r';
      case 0x0441:
        return 's';
      case 0x0442:
        return 't';
      case 0x0443:
        return 'u';
      case 0x0444:
        return 'f';
      case 0x0445:
        return 'kh';
      case 0x0446:
        return 'ts';
      case 0x0447:
        return 'ch';
      case 0x0448:
        return 'sh';
      case 0x0449:
        return 'shch';
      case 0x044B:
        return 'y';
      case 0x044E:
        return 'yu';
      case 0x044F:
        return 'ya';
      default:
        return String.fromCharCode(rune);
    }
  }

  MapEntry<String, String>? _matchLongest(String text, int start) {
    final rem = text.substring(start).toLowerCase();
    for (var len = 4; len >= 1; len--) {
      if (rem.length >= len) {
        final sub = rem.substring(0, len);
        if (charMap.containsKey(sub)) return MapEntry(sub, charMap[sub]!);
      }
    }
    return null;
  }
}
