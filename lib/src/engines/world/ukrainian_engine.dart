import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Ukrainian Transliteration Engine supporting Ukrainian Cyrillic alphabet
/// and Ukrainian National Romanization (Resolution No. 55) & ISO 9 standard.
class UkrainianEngine implements TransliteratorEngine {
  @override
  String get id => 'ukrainian-engine';

  @override
  String get scheme => 'ukrainian-national-55';

  @override
  String get version => '0.1.0';

  static const Map<String, String> commonWords = {
    'pryvit': 'привіт',
    'dyakuyu': 'дякую',
    'dobryi den': 'добрий день',
    'dobryy den': 'добрий день',
    'dobry den': 'добрий день',
    'dobryi': 'добрий',
    'dobryy': 'добрий',
    'ukrayina': 'україна',
    'do pobachennya': 'до побачення',
    'tak': 'так',
    'ni': 'ні',
    'bud laska': 'будь ласка',
  };

  static const Map<String, String> latinToUkrainianMulti = {
    'shch': '\u0449', // щ
    'zh': '\u0436', // ж
    'kh': '\u0445', // х
    'ts': '\u0446', // ц
    'ch': '\u0447', // ч
    'sh': '\u0448', // ш
    'yu': '\u044E', // ю
    'ya': '\u044F', // я
    'ye': '\u0454', // є
    'yi': '\u0457', // ї
  };

  static const Map<String, String> latinToUkrainianSingle = {
    'a': '\u0430', // а
    'b': '\u0431', // б
    'v': '\u0432', // в
    'h': '\u0433', // г
    'g': '\u0491', // ґ
    'd': '\u0434', // д
    'e': '\u0435', // е
    'z': '\u0437', // з
    'y': '\u0438', // и
    'i': '\u0456', // і
    'k': '\u043A', // к
    'l': '\u043B', // л
    'm': '\u043C', // м
    'n': '\u043D', // н
    'o': '\u043E', // о
    'p': '\u043F', // п
    'r': '\u0440', // р
    's': '\u0441', // с
    't': '\u0442', // т
    'u': '\u0443', // у
    'f': '\u0444', // ф
  };

  static const Map<String, String> ukrainianToLatinMap = {
    '\u0430': 'a',
    '\u0431': 'b',
    '\u0432': 'v',
    '\u0433': 'h',
    '\u0491': 'g',
    '\u0434': 'd',
    '\u0435': 'e',
    '\u0454': 'ye',
    '\u0436': 'zh',
    '\u0437': 'z',
    '\u0438': 'y',
    '\u0456': 'i',
    '\u0457': 'yi',
    '\u0439': 'y',
    '\u043A': 'k',
    '\u043B': 'l',
    '\u043C': 'm',
    '\u043D': 'n',
    '\u043E': 'o',
    '\u043F': 'p',
    '\u0440': 'r',
    '\u0441': 's',
    '\u0442': 't',
    '\u0443': 'u',
    '\u0444': 'f',
    '\u0445': 'kh',
    '\u0446': 'ts',
    '\u0447': 'ch',
    '\u0448': 'sh',
    '\u0449': 'shch',
    '\u044C': '',
    '\u044E': 'yu',
    '\u044F': 'ya',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedLanguage;
    final t = to.normalizedLanguage;
    final fScript = from.normalizedScript;
    final tScript = to.normalizedScript;

    return (fScript == 'Latn' && t == 'uk' && tScript == 'Cyrl') ||
        (f == 'uk' && fScript == 'Cyrl' && tScript == 'Latn');
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatinToUk =
        request.from.normalizedLanguage == 'en' ||
        request.from.normalizedScript == 'Latn';
    final text = request.text;
    final converted = isLatinToUk
        ? _latinToUkrainian(text)
        : _ukrainianToLatin(text);

    return ConversionResult(
      text: converted,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }

  String _latinToUkrainian(String text) {
    if (text.isEmpty) return '';

    var result = text;
    // 1. Replace multi-word common phrases with word boundaries
    for (final entry in commonWords.entries) {
      final pattern = RegExp(
        '\\b${RegExp.escape(entry.key)}\\b',
        caseSensitive: false,
      );
      result = result.replaceAllMapped(pattern, (m) {
        final matchStr = m.group(0)!;
        final val = entry.value;
        if (matchStr.isNotEmpty &&
            matchStr[0].toUpperCase() == matchStr[0] &&
            matchStr[0].toLowerCase() != matchStr[0]) {
          return val[0].toUpperCase() + val.substring(1);
        }
        return val;
      });
    }

    final words = result.split(' ');
    final resultWords = <String>[];

    for (final word in words) {
      final punctRegex = RegExp(r'^([^a-zA-Z0-9]*)(.*?)([^a-zA-Z0-9]*)$');
      final match = punctRegex.firstMatch(word);
      if (match == null) {
        resultWords.add(word);
        continue;
      }

      final prefix = match.group(1) ?? '';
      final core = match.group(2) ?? '';
      final suffix = match.group(3) ?? '';

      final lowerCore = core.toLowerCase();
      final isCapital =
          core.isNotEmpty &&
          core[0].toUpperCase() == core[0] &&
          core[0].toLowerCase() != core[0];

      String converted;
      if (commonWords.containsKey(lowerCore)) {
        converted = commonWords[lowerCore]!;
      } else {
        converted = _convertWordToUkrainian(core);
      }

      if (isCapital && converted.isNotEmpty) {
        converted = converted[0].toUpperCase() + converted.substring(1);
      }
      resultWords.add('$prefix$converted$suffix');
    }

    return resultWords.join(' ');
  }

  String _convertWordToUkrainian(String word) {
    final buffer = StringBuffer();
    int i = 0;
    final lower = word.toLowerCase();

    while (i < lower.length) {
      if (i + 4 <= lower.length) {
        final quad = lower.substring(i, i + 4);
        if (latinToUkrainianMulti.containsKey(quad)) {
          buffer.write(latinToUkrainianMulti[quad]);
          i += 4;
          continue;
        }
      }

      if (i + 2 <= lower.length) {
        final pair = lower.substring(i, i + 2);
        if (latinToUkrainianMulti.containsKey(pair)) {
          buffer.write(latinToUkrainianMulti[pair]);
          i += 2;
          continue;
        }
      }

      final single = lower[i];
      if (latinToUkrainianSingle.containsKey(single)) {
        buffer.write(latinToUkrainianSingle[single]);
      } else {
        buffer.write(word[i]);
      }
      i++;
    }

    return buffer.toString();
  }

  String _ukrainianToLatin(String text) {
    if (text.isEmpty) return '';

    for (final entry in commonWords.entries) {
      if (text.trim() == entry.value) {
        final k = entry.key;
        return k[0].toUpperCase() + k.substring(1);
      }
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      buffer.write(ukrainianToLatinMap[char] ?? char);
    }
    return buffer.toString();
  }
}
