import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Armenian Transliteration Engine supporting Armenian script (Unicode 0x0530 - 0x058F)
/// and ISO 9985 / Classical Armenian Romanization.
class ArmenianEngine implements TransliteratorEngine {
  @override
  String get id => 'armenian-engine';

  @override
  String get scheme => 'armenian-iso-9985';

  @override
  String get version => '0.1.0';

  static const Map<String, String> commonWords = {
    'barev': 'բարև',
    'shnorhakalutyun': 'շնորհակալություն',
    'hajoghutyun': 'հաջողություն',
    'hayastan': 'հայաստան',
    'inchpes es': 'ինչպես ես',
    'ayo': 'այո',
    'voch': 'ոչ',
    'bari luys': 'բարի լույս',
  };

  static const Map<String, String> latinToArmenianMulti = {
    'kh': '\u056D', // խ
    'ts': '\u056E', // ծ
    'dz': '\u0571', // ձ
    'gh': '\u0572', // ղ
    'ch': '\u0573', // ճ
    'sh': '\u0577', // շ
    'vo': '\u0578', // ո
    'ev': '\u0587', // և
    'ye': '\u0565', // ե
    'zh': '\u0566', // ժ
  };

  static const Map<String, String> latinToArmenianSingle = {
    'a': '\u0561', // ա
    'b': '\u0562', // բ
    'g': '\u0563', // գ
    'd': '\u0564', // դ
    'e': '\u0565', // ե
    'z': '\u0566', // զ
    'i': '\u056B', // ի
    'l': '\u056C', // լ
    'k': '\u056F', // կ
    'h': '\u0570', // հ
    'm': '\u0574', // մ
    'y': '\u0575', // յ
    'n': '\u0576', // ն
    'o': '\u0585', // օ
    'p': '\u057A', // պ
    'j': '\u057B', // ջ
    'r': '\u0580', // ր
    's': '\u057D', // ս
    'v': '\u057E', // վ
    't': '\u057F', // տ
    'u': '\u0578\u0582', // ու
    'f': '\u0586', // ֆ
  };

  static const Map<String, String> armenianToLatinMap = {
    '\u0561': 'a',
    '\u0562': 'b',
    '\u0563': 'g',
    '\u0564': 'd',
    '\u0565': 'e',
    '\u0566': 'z',
    '\u0567': 'e',
    '\u0568': 'y',
    '\u0569': 't',
    '\u056A': 'zh',
    '\u056B': 'i',
    '\u056C': 'l',
    '\u056D': 'kh',
    '\u056E': 'ts',
    '\u056F': 'k',
    '\u0570': 'h',
    '\u0571': 'dz',
    '\u0572': 'gh',
    '\u0573': 'ch',
    '\u0574': 'm',
    '\u0575': 'y',
    '\u0576': 'n',
    '\u0577': 'sh',
    '\u0578': 'vo',
    '\u0579': 'ch',
    '\u057A': 'p',
    '\u057B': 'j',
    '\u057C': 'r',
    '\u057D': 's',
    '\u057E': 'v',
    '\u057F': 't',
    '\u0580': 'r',
    '\u0581': 'ts',
    '\u0582': 'u',
    '\u0583': 'p',
    '\u0584': 'k',
    '\u0585': 'o',
    '\u0586': 'f',
    '\u0587': 'ev',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedLanguage;
    final t = to.normalizedLanguage;
    final fScript = from.normalizedScript;
    final tScript = to.normalizedScript;

    return (f == 'en' && (t == 'hy' || tScript == 'Armn')) ||
        ((f == 'hy' || fScript == 'Armn') && (t == 'en' || tScript == 'Latn'));
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatinToArmn = request.from.normalizedLanguage == 'en' ||
        request.from.normalizedScript == 'Latn';
    final text = request.text;
    final converted = isLatinToArmn ? _latinToArmenian(text) : _armenianToLatin(text);

    return ConversionResult(
      text: converted,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }

  String _latinToArmenian(String text) {
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

      final convertedCore = _convertWordToArmenian(core);
      resultWords.add('$prefix$convertedCore$suffix');
    }

    return resultWords.join(' ');
  }

  String _convertWordToArmenian(String word) {
    final buffer = StringBuffer();
    int i = 0;
    final lower = word.toLowerCase();

    while (i < lower.length) {
      if (i + 2 <= lower.length) {
        final pair = lower.substring(i, i + 2);
        if (latinToArmenianMulti.containsKey(pair)) {
          buffer.write(latinToArmenianMulti[pair]);
          i += 2;
          continue;
        }
      }

      final single = lower[i];
      if (latinToArmenianSingle.containsKey(single)) {
        buffer.write(latinToArmenianSingle[single]);
      } else {
        buffer.write(word[i]);
      }
      i++;
    }

    return buffer.toString();
  }

  String _armenianToLatin(String text) {
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
      buffer.write(armenianToLatinMap[char] ?? char);
    }
    return buffer.toString();
  }
}
