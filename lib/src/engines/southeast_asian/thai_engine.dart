import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Thai Transliteration Engine supporting RTGS (Royal Thai General System of Transcription)
/// and phonetic mapping between Latin and Thai script (Unicode 0x0E00 - 0x0E7F).
class ThaiEngine implements TransliteratorEngine {
  @override
  String get id => 'thai-engine';

  @override
  String get scheme => 'thai-rtgs-standard';

  @override
  String get version => '0.1.0';

  static const Map<String, String> commonWords = {
    'sawatdee': 'สวัสดี',
    'sawatdi': 'สวัสดี',
    'khop khun': 'ขอบคุณ',
    'khob khun': 'ขอบคุณ',
    'sabai dee': 'สบายดี',
    'sabai di': 'สบายดี',
    'laa korn': 'ลาก่อน',
    'la korn': 'ลาก่อน',
    'chai': 'ใช่',
    'mai': 'ไม่',
    'muang thai': 'เมืองไทย',
    'bangkok': 'บางกอก',
    'chok dee': 'โชคดี',
    'yin dee': 'ยินดี',
  };

  static const Map<String, String> latinToThaiConsonants = {
    'kh': '\u0E02',
    'ng': '\u0E07',
    'ch': '\u0E08',
    'th': '\u0E17',
    'ph': '\u0E1E',
    'k': '\u0E01',
    'g': '\u0E01',
    'j': '\u0E08',
    'd': '\u0E14',
    't': '\u0E15',
    'n': '\u0E19',
    'b': '\u0E1A',
    'p': '\u0E1B',
    'f': '\u0E1F',
    'm': '\u0E21',
    'y': '\u0E22',
    'r': '\u0E23',
    'l': '\u0E25',
    'w': '\u0E27',
    's': '\u0E2A',
    'h': '\u0E2B',
  };

  static const Map<String, String> thaiToLatinMap = {
    '\u0E01': 'k',
    '\u0E02': 'kh',
    '\u0E03': 'kh',
    '\u0E04': 'kh',
    '\u0E07': 'ng',
    '\u0E08': 'ch',
    '\u0E09': 'ch',
    '\u0E0A': 'ch',
    '\u0E0D': 'y',
    '\u0E0E': 'd',
    '\u0E0F': 't',
    '\u0E14': 'd',
    '\u0E15': 't',
    '\u0E16': 'th',
    '\u0E17': 'th',
    '\u0E18': 'th',
    '\u0E19': 'n',
    '\u0E1A': 'b',
    '\u0E1B': 'p',
    '\u0E1C': 'ph',
    '\u0E1D': 'f',
    '\u0E1E': 'ph',
    '\u0E1F': 'f',
    '\u0E20': 'ph',
    '\u0E21': 'm',
    '\u0E22': 'y',
    '\u0E23': 'r',
    '\u0E24': 'rue',
    '\u0E25': 'l',
    '\u0E27': 'w',
    '\u0E28': 's',
    '\u0E29': 's',
    '\u0E2A': 's',
    '\u0E2B': 'h',
    '\u0E2C': 'l',
    '\u0E2E': 'h',
    '\u0E30': 'a',
    '\u0E31': 'a',
    '\u0E32': 'aa',
    '\u0E34': 'i',
    '\u0E35': 'ii',
    '\u0E36': 'ue',
    '\u0E37': 'uee',
    '\u0E38': 'u',
    '\u0E39': 'uu',
    '\u0E40': 'e',
    '\u0E41': 'ae',
    '\u0E42': 'o',
    '\u0E43': 'ai',
    '\u0E44': 'ai',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedLanguage;
    final t = to.normalizedLanguage;
    final fScript = from.normalizedScript;
    final tScript = to.normalizedScript;

    return (f == 'en' && (t == 'th' || tScript == 'Thai')) ||
        ((f == 'th' || fScript == 'Thai') && (t == 'en' || tScript == 'Latn'));
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatinToThai = request.from.normalizedLanguage == 'en' ||
        request.from.normalizedScript == 'Latn';
    final text = request.text;
    final converted = isLatinToThai ? _latinToThai(text) : _thaiToLatin(text);

    return ConversionResult(
      text: converted,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }

  String _latinToThai(String text) {
    if (text.isEmpty) return '';

    var result = text;
    // 1. Replace multi-word common phrases with word boundaries
    for (final entry in commonWords.entries) {
      final pattern = RegExp('\\b${RegExp.escape(entry.key)}\\b', caseSensitive: false);
      result = result.replaceAllMapped(pattern, (m) => entry.value);
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
      if (commonWords.containsKey(lowerCore)) {
        resultWords.add('$prefix${commonWords[lowerCore]!}$suffix');
        continue;
      }

      // Character-level phonetic conversion
      final convertedCore = _convertWordToThai(core);
      resultWords.add('$prefix$convertedCore$suffix');
    }

    return resultWords.join(' ');
  }

  String _convertWordToThai(String word) {
    final buffer = StringBuffer();
    int i = 0;
    final lower = word.toLowerCase();

    while (i < lower.length) {
      // 1. Check 2-letter consonant matches
      if (i + 1 < lower.length) {
        final pair = lower.substring(i, i + 2);
        if (latinToThaiConsonants.containsKey(pair)) {
          buffer.write(latinToThaiConsonants[pair]);
          i += 2;
          continue;
        }
      }

      // 2. Check single consonant matches
      final single = lower[i];
      if (latinToThaiConsonants.containsKey(single)) {
        buffer.write(latinToThaiConsonants[single]);
        i += 1;
        continue;
      }

      // 3. Vowels
      if (single == 'a') {
        buffer.write('\u0E32');
      } else if (single == 'i') {
        buffer.write('\u0E34');
      } else if (single == 'u') {
        buffer.write('\u0E38');
      } else if (single == 'e') {
        buffer.write('\u0E40');
      } else if (single == 'o') {
        buffer.write('\u0E42');
      } else {
        buffer.write(word[i]);
      }
      i++;
    }

    return buffer.toString();
  }

  String _thaiToLatin(String text) {
    if (text.isEmpty) return '';

    // Check common words reverse
    for (final entry in commonWords.entries) {
      if (text.trim() == entry.value) {
        final k = entry.key;
        return k[0].toUpperCase() + k.substring(1);
      }
    }

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      buffer.write(thaiToLatinMap[char] ?? char);
    }
    return buffer.toString();
  }
}
