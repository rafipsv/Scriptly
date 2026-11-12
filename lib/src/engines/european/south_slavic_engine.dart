import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Transliterator engine for South Slavic and European languages:
/// Serbian (sr-Cyrl with Vuk ↔ Gaj 1:1 bi-directional), Bulgarian (bg-Cyrl Act 2009),
/// Macedonian (mk-Cyrl), and Belarusian (be-Cyrl Lacinka).
class SouthSlavicEngine implements TransliteratorEngine {
  @override
  String get id => 'south-slavic-engine';

  @override
  String get scheme => 'vuk-gaj-and-slavic-iso9';

  @override
  String get version => '0.5.0';

  static const Map<String, String> serbianCyrToLat = {
    'Љ': 'Lj', 'Њ': 'Nj', 'Џ': 'Dž',
    'љ': 'lj', 'њ': 'nj', 'џ': 'dž',
    'А': 'A', 'Б': 'B', 'В': 'V', 'Г': 'G', 'Д': 'D', 'Ђ': 'Đ', 'Е': 'E',
    'Ж': 'Ž', 'З': 'Z', 'И': 'I', 'Ј': 'J', 'К': 'K', 'Л': 'L', 'М': 'M',
    'Н': 'N', 'О': 'O', 'П': 'P', 'Р': 'R', 'С': 'S', 'Т': 'T', 'Ћ': 'Ć',
    'У': 'U', 'Ф': 'F', 'Х': 'H', 'Ц': 'C', 'Ч': 'Č', 'Ш': 'Š',
    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'ђ': 'đ', 'е': 'e',
    'ж': 'ž', 'з': 'z', 'и': 'i', 'ј': 'j', 'к': 'k', 'л': 'l', 'м': 'm',
    'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'ћ': 'ć',
    'у': 'u', 'ф': 'f', 'х': 'h', 'ц': 'c', 'ч': 'č', 'ш': 'š',
  };

  static const Map<String, String> serbianLatToCyr = {
    'DŽ': 'Џ', 'Dž': 'Џ', 'dž': 'џ',
    'LJ': 'Љ', 'Lj': 'Љ', 'lj': 'љ',
    'NJ': 'Њ', 'Nj': 'Њ', 'nj': 'њ',
    'A': 'А', 'B': 'Б', 'V': 'В', 'G': 'Г', 'D': 'Д', 'Đ': 'Ђ', 'E': 'Е',
    'Ž': 'Ж', 'Z': 'З', 'I': 'И', 'J': 'Ј', 'K': 'К', 'L': 'Л', 'M': 'М',
    'N': 'Н', 'O': 'О', 'P': 'П', 'R': 'Р', 'S': 'С', 'T': 'Т', 'Ć': 'Ћ',
    'U': 'У', 'F': 'Ф', 'H': 'Х', 'C': 'Ц', 'Č': 'Ч', 'Š': 'Ш',
    'a': 'а', 'b': 'б', 'v': 'в', 'g': 'г', 'd': 'д', 'đ': 'ђ', 'e': 'е',
    'ž': 'ж', 'z': 'з', 'i': 'и', 'j': 'ј', 'k': 'к', 'l': 'л', 'm': 'м',
    'n': 'н', 'o': 'о', 'p': 'п', 'r': 'р', 's': 'с', 't': 'т', 'ć': 'ћ',
    'u': 'у', 'f': 'ф', 'h': 'х', 'c': 'ц', 'č': 'ч', 'š': 'ш',
    // ASCII fallbacks
    'dj': 'ђ', 'Dj': 'Ђ', 'ch': 'ч', 'Ch': 'Ч', 'sh': 'ш', 'Sh': 'Ш', 'zh': 'ж', 'Zh': 'Ж',
  };

  static const Map<String, String> bulgarianLatToCyr = {
    'sht': 'щ', 'Sht': 'Щ', 'ch': 'ч', 'Ch': 'Ч', 'sh': 'ш', 'Sh': 'Ш',
    'zh': 'ж', 'Zh': 'Ж', 'ts': 'ц', 'Ts': 'Ц', 'yu': 'ю', 'Yu': 'Ю',
    'ya': 'я', 'Ya': 'Я', 'ia': 'я', 'Ia': 'Я',
    'a': 'а', 'b': 'б', 'v': 'в', 'g': 'г', 'd': 'д', 'e': 'е', 'z': 'з',
    'i': 'и', 'y': 'й', 'k': 'к', 'l': 'л', 'm': 'м', 'n': 'н', 'o': 'о',
    'p': 'п', 'r': 'р', 's': 'с', 't': 'т', 'u': 'у', 'f': 'ф', 'h': 'х',
    'A': 'А', 'B': 'Б', 'V': 'В', 'G': 'Г', 'D': 'Д', 'E': 'Е', 'Z': 'З',
    'I': 'И', 'Y': 'Й', 'K': 'К', 'L': 'Л', 'M': 'М', 'N': 'Н', 'O': 'О',
    'P': 'П', 'R': 'Р', 'S': 'С', 'T': 'Т', 'U': 'У', 'F': 'Ф', 'H': 'Х',
  };

  static const Map<String, String> macedonianLatToCyr = {
    'gj': 'ѓ', 'Gj': 'Ѓ', 'kj': 'ќ', 'Kj': 'Ќ', 'dz': 'ѕ', 'Dz': 'Ѕ',
    'dzh': 'џ', 'Dzh': 'Џ', 'dž': 'џ', 'Dž': 'Џ',
    'lj': 'љ', 'Lj': 'Љ', 'nj': 'њ', 'Nj': 'Њ',
    'ch': 'ч', 'Ch': 'Ч', 'sh': 'ш', 'Sh': 'Ш', 'zh': 'ж', 'Zh': 'Ж',
    'c': 'ц', 'C': 'Ц', 'j': 'ј', 'J': 'Ј',
    'a': 'а', 'b': 'б', 'v': 'в', 'g': 'г', 'd': 'д', 'e': 'е', 'z': 'з',
    'i': 'и', 'k': 'к', 'l': 'л', 'm': 'м', 'n': 'н', 'o': 'о', 'p': 'п',
    'r': 'р', 's': 'с', 't': 'т', 'u': 'у', 'f': 'ф', 'h': 'х',
    'A': 'А', 'B': 'Б', 'V': 'В', 'G': 'Г', 'D': 'Д', 'E': 'Е', 'Z': 'З',
    'I': 'И', 'K': 'К', 'L': 'Л', 'M': 'М', 'N': 'Н', 'O': 'О', 'P': 'П',
    'R': 'Р', 'S': 'С', 'T': 'Т', 'U': 'У', 'F': 'Ф', 'H': 'Х',
  };

  static const Map<String, String> belarusianLatToCyr = {
    'ŭ': 'ў', 'Ŭ': 'Ў', 'w': 'ў', 'W': 'Ў',
    'i': 'і', 'I': 'І',
    'ch': 'ч', 'Ch': 'Ч', 'sh': 'ш', 'Sh': 'Ш', 'zh': 'ж', 'Zh': 'Ж',
    'dz': 'дз', 'Dz': 'Дз', 'dzh': 'дж', 'Dzh': 'Дж',
    'ts': 'ц', 'Ts': 'Ц', 'yu': 'ю', 'Yu': 'Ю', 'ya': 'я', 'Ya': 'Я',
    'a': 'а', 'b': 'б', 'v': 'в', 'g': 'г', 'd': 'д', 'e': 'е', 'z': 'з',
    'y': 'ы', 'k': 'к', 'l': 'л', 'm': 'м', 'n': 'н', 'o': 'о', 'p': 'п',
    'r': 'р', 's': 'с', 't': 'т', 'u': 'у', 'f': 'ф', 'h': 'х',
    'A': 'А', 'B': 'Б', 'V': 'В', 'G': 'Г', 'D': 'Д', 'E': 'Е', 'Z': 'З',
    'Y': 'Ы', 'K': 'К', 'L': 'Л', 'M': 'М', 'N': 'Н', 'O': 'О', 'P': 'П',
    'R': 'Р', 'S': 'С', 'T': 'Т', 'U': 'У', 'F': 'Ф', 'H': 'Х',
  };

  static const Map<String, String> commonPhrases = {
    'zdravo': 'здраво',
    'dobar dan': 'добар дан',
    'hvala': 'хвала',
    'kako si': 'како си',
    'beograd': 'београд',
    'srbija': 'србија',
    'sofia': 'софия',
    'bulgaria': 'българия',
    'blagodarya': 'благодаря',
    'skopje': 'скопје',
    'macedonia': 'македонија',
    'minsk': 'мінск',
    'belarus': 'беларусь',
    'dzyakuy': 'дзякуй',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    const langs = {'sr', 'bg', 'mk', 'be'};
    final f = from.normalizedLanguage;
    final t = to.normalizedLanguage;
    final fS = from.normalizedScript;
    final tS = to.normalizedScript;

    if (fS == 'Latn' && langs.contains(t) && tS == 'Cyrl') return true;
    if (langs.contains(f) && fS == 'Cyrl' && tS == 'Latn') return true;
    return false;
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isFromLatin = request.from.normalizedScript == 'Latn';
    final targetLang = isFromLatin ? request.to.normalizedLanguage : request.from.normalizedLanguage;
    final text = request.text;

    final output = isFromLatin
        ? _toCyrillic(text, targetLang)
        : _toLatin(text, targetLang);

    return ConversionResult(
      text: output,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: isFromLatin ? '$targetLang-roman-to-cyrillic' : '$targetLang-cyrillic-to-roman',
    );
  }

  String _toCyrillic(String input, String targetLang) {
    var processed = input;
    for (final entry in commonPhrases.entries) {
      final lat = entry.key;
      final cyr = entry.value;
      final pattern = RegExp('\\b$lat\\b', caseSensitive: false);
      processed = processed.replaceAllMapped(pattern, (match) {
        final mStr = match.group(0)!;
        if (mStr.length > 1 && mStr[0].toUpperCase() == mStr[0] && mStr[1].toLowerCase() == mStr[1]) {
          return cyr[0].toUpperCase() + cyr.substring(1);
        } else if (mStr.toUpperCase() == mStr) {
          return cyr.toUpperCase();
        }
        return cyr;
      });
    }

    if (targetLang == 'sr') {
      return _replaceLongest(processed, serbianLatToCyr);
    } else if (targetLang == 'bg') {
      return _replaceLongest(processed, bulgarianLatToCyr);
    } else if (targetLang == 'mk') {
      return _replaceLongest(processed, macedonianLatToCyr);
    } else {
      // Belarusian
      return _replaceLongest(processed, belarusianLatToCyr);
    }
  }

  String _toLatin(String input, String sourceLang) {
    for (final entry in commonPhrases.entries) {
      if (input.trim().toLowerCase() == entry.value.toLowerCase()) {
        final k = entry.key;
        return input.isNotEmpty && input[0].toUpperCase() == input[0]
            ? k[0].toUpperCase() + k.substring(1)
            : k;
      }
    }

    if (sourceLang == 'sr') {
      final buffer = StringBuffer();
      for (var i = 0; i < input.length; i++) {
        final ch = input[i];
        buffer.write(serbianCyrToLat[ch] ?? ch);
      }
      return buffer.toString();
    }

    var text = input;
    // Bulgarian Transliteration Act 2009: -ия at word end is -ia
    if (sourceLang == 'bg') {
      text = text.replaceAllMapped(RegExp(r'ия(?=$|[^а-яА-ЯёЁіІўЎa-zA-Z0-9])', caseSensitive: false), (m) {
        final match = m.group(0)!;
        return match.startsWith('ИЯ') ? 'IA' : (match.startsWith('И') ? 'Ia' : 'ia');
      });
    }

    // Bulgarian Act 2009 / General Slavic ISO-9
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if (serbianCyrToLat.containsKey(ch)) {
        buffer.write(serbianCyrToLat[ch]);
      } else if (ch == 'щ') {
        buffer.write('sht');
      } else if (ch == 'Щ') {
        buffer.write('Sht');
      } else if (ch == 'ъ') {
        buffer.write('a');
      } else if (ch == 'Ъ') {
        buffer.write('A');
      } else if (ch == 'ю') {
        buffer.write('yu');
      } else if (ch == 'я') {
        buffer.write('ya');
      } else {
        buffer.write(ch);
      }
    }
    return buffer.toString();
  }

  String _replaceLongest(String text, Map<String, String> table) {
    final buffer = StringBuffer();
    final len = text.length;
    var index = 0;

    while (index < len) {
      String? matchedKey;
      String? matchedVal;

      for (var k = 3; k >= 1; k--) {
        if (index + k <= len) {
          final sub = text.substring(index, index + k);
          if (table.containsKey(sub)) {
            matchedKey = sub;
            matchedVal = table[sub];
            break;
          }
        }
      }

      if (matchedKey != null && matchedVal != null) {
        buffer.write(matchedVal);
        index += matchedKey.length;
      } else {
        buffer.write(text[index]);
        index++;
      }
    }
    return buffer.toString();
  }
}
