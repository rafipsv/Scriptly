import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Georgian Transliteration Engine supporting Mkhedruli script (Unicode 0x10D0 - 0x10FF)
/// and the Georgian National System of Romanization (2002).
class GeorgianEngine implements TransliteratorEngine {
  @override
  String get id => 'georgian-engine';

  @override
  String get scheme => 'georgian-national-2002';

  @override
  String get version => '0.1.0';

  static const Map<String, String> commonWords = {
    'gamarjoba': 'გამარჯობა',
    'madloba': 'მადლობა',
    'nakhvamdis': 'ნახვამდის',
    'sakartvelo': 'საქართველო',
    'rogor khar': 'როგორ ხარ',
    'ara': 'არა',
    'ki': 'კი',
    'ho': 'ჰო',
    'dila mshvidobisa': 'დილა მშვიდობისა',
  };

  static const Map<String, String> latinToGeorgianMulti = {
    "ch'": '\u10ED', // ჭ
    "ts'": '\u10EC', // წ
    "k'": '\u10D9', // კ
    "p'": '\u10DE', // პ
    "t'": '\u10E2', // ტ
    "q'": '\u10E7', // ყ
    'zh': '\u10DF', // ჟ
    'gh': '\u10E6', // ღ
    'sh': '\u10E8', // შ
    'ch': '\u10E9', // ჩ
    'ts': '\u10EA', // ც
    'dz': '\u10EB', // ძ
    'kh': '\u10EE', // ხ
  };

  static const Map<String, String> latinToGeorgianSingle = {
    'a': '\u10D0', // ა
    'b': '\u10D1', // ბ
    'g': '\u10D2', // გ
    'd': '\u10D3', // დ
    'e': '\u10D4', // ე
    'v': '\u10D5', // ვ
    'z': '\u10D6', // ზ
    't': '\u10D7', // თ
    'i': '\u10D8', // ი
    'l': '\u10DA', // ლ
    'm': '\u10DB', // მ
    'n': '\u10DC', // ნ
    'o': '\u10DD', // ო
    'r': '\u10E0', // რ
    's': '\u10E1', // ს
    'u': '\u10E3', // უ
    'p': '\u10E4', // ფ
    'k': '\u10E5', // ქ
    'j': '\u10EF', // ჯ
    'h': '\u10F0', // ჰ
  };

  static const Map<String, String> georgianToLatinMap = {
    '\u10D0': 'a',
    '\u10D1': 'b',
    '\u10D2': 'g',
    '\u10D3': 'd',
    '\u10D4': 'e',
    '\u10D5': 'v',
    '\u10D6': 'z',
    '\u10D7': 't',
    '\u10D8': 'i',
    '\u10D9': "k'",
    '\u10DA': 'l',
    '\u10DB': 'm',
    '\u10DC': 'n',
    '\u10DD': 'o',
    '\u10DE': "p'",
    '\u10DF': 'zh',
    '\u10E0': 'r',
    '\u10E1': 's',
    '\u10E2': "t'",
    '\u10E3': 'u',
    '\u10E4': 'p',
    '\u10E5': 'k',
    '\u10E6': 'gh',
    '\u10E7': "q'",
    '\u10E8': 'sh',
    '\u10E9': 'ch',
    '\u10EA': 'ts',
    '\u10EB': 'dz',
    '\u10EC': "ts'",
    '\u10ED': "ch'",
    '\u10EE': 'kh',
    '\u10EF': 'j',
    '\u10F0': 'h',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedLanguage;
    final t = to.normalizedLanguage;
    final fScript = from.normalizedScript;
    final tScript = to.normalizedScript;

    return (f == 'en' && (t == 'ka' || tScript == 'Geor')) ||
        ((f == 'ka' || fScript == 'Geor') && (t == 'en' || tScript == 'Latn'));
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatinToGeor =
        request.from.normalizedLanguage == 'en' ||
        request.from.normalizedScript == 'Latn';
    final text = request.text;
    final converted = isLatinToGeor
        ? _latinToGeorgian(text)
        : _georgianToLatin(text);

    return ConversionResult(
      text: converted,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }

  String _latinToGeorgian(String text) {
    if (text.isEmpty) return '';

    final lower = text.trim().toLowerCase();
    if (commonWords.containsKey(lower)) {
      return commonWords[lower]!;
    }

    final words = text.split(' ');
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
      if (commonWords.containsKey(lowerCore)) {
        resultWords.add('$prefix${commonWords[lowerCore]!}$suffix');
        continue;
      }

      // Convert letter by letter with longest match
      final convertedCore = _convertWordToGeorgian(core);
      resultWords.add('$prefix$convertedCore$suffix');
    }

    return resultWords.join(' ');
  }

  String _convertWordToGeorgian(String word) {
    final buffer = StringBuffer();
    int i = 0;
    final lower = word.toLowerCase();

    while (i < lower.length) {
      // 1. Try 3-char match (e.g., ch', ts')
      if (i + 3 <= lower.length) {
        final tri = lower.substring(i, i + 3);
        if (latinToGeorgianMulti.containsKey(tri)) {
          buffer.write(latinToGeorgianMulti[tri]);
          i += 3;
          continue;
        }
      }

      // 2. Try 2-char match (e.g., zh, gh, sh, ch, ts, dz, kh, k', p', t', q')
      if (i + 2 <= lower.length) {
        final pair = lower.substring(i, i + 2);
        if (latinToGeorgianMulti.containsKey(pair)) {
          buffer.write(latinToGeorgianMulti[pair]);
          i += 2;
          continue;
        }
      }

      // 3. Single character
      final single = lower[i];
      if (latinToGeorgianSingle.containsKey(single)) {
        buffer.write(latinToGeorgianSingle[single]);
      } else {
        buffer.write(word[i]);
      }
      i++;
    }

    return buffer.toString();
  }

  String _georgianToLatin(String text) {
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
      buffer.write(georgianToLatinMap[char] ?? char);
    }
    return buffer.toString();
  }
}
