import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Transliteration engine for Chinese Pinyin: converts numeric tone markers to diacritics
/// (e.g. 'ni3 hao3' -> 'nǐ hǎo', 'zhong1 guo2' -> 'zhōng guó').
class PinyinEngine implements TransliteratorEngine {
  @override
  String get id => 'chinese-pinyin-engine';

  @override
  String get scheme => 'pinyin-tone-diacritics';

  @override
  String get version => '0.2.0';

  static const Map<String, List<String>> vowelsWithTones = {
    'a': ['a', 'ā', 'á', 'ǎ', 'à'],
    'e': ['e', 'ē', 'é', 'ě', 'è'],
    'i': ['i', 'ī', 'í', 'ǐ', 'ì'],
    'o': ['o', 'ō', 'ó', 'ǒ', 'ò'],
    'u': ['u', 'ū', 'ú', 'ǔ', 'ù'],
    'v': ['ü', 'ǖ', 'ǘ', 'ǚ', 'ǜ'],
  };

  static const Map<String, String> commonWords = {
    'ni hao': 'nǐ hǎo',
    'xiexie': 'xièxiè',
    'zaijian': 'zàijiàn',
    'zhongguo': 'zhōngguó',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    return from.normalizedLanguage == 'zh' || to.normalizedLanguage == 'zh';
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final output = _convertPinyin(request.text);
    return ConversionResult(
      text: output,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }

  String _convertPinyin(String input) {
    final lower = input.toLowerCase().trim();
    if (commonWords.containsKey(lower)) {
      return commonWords[lower]!;
    }

    // Replace tone numbers: e.g. ni3 -> nǐ
    final pattern = RegExp(r'([a-zA-Z]+)([1-5])');
    return input.replaceAllMapped(pattern, (match) {
      final syllable = match.group(1)!;
      final tone = int.parse(match.group(2)!);
      if (tone == 5 || tone == 0) return syllable;

      // Find vowel to place tone mark on (priority: a, e, o, or last vowel)
      var targetVowel = '';
      for (final v in ['a', 'e', 'o']) {
        if (syllable.contains(v)) {
          targetVowel = v;
          break;
        }
      }
      if (targetVowel.isEmpty) {
        if (syllable.contains('ui')) {
          targetVowel = 'i';
        } else if (syllable.contains('iu')) {
          targetVowel = 'u';
        } else {
          for (final char in syllable.split('').reversed) {
            if (vowelsWithTones.containsKey(char.toLowerCase())) {
              targetVowel = char.toLowerCase();
              break;
            }
          }
        }
      }

      if (targetVowel.isNotEmpty && vowelsWithTones.containsKey(targetVowel)) {
        final marked = vowelsWithTones[targetVowel]![tone];
        return syllable.replaceFirst(targetVowel, marked);
      }

      return syllable;
    });
  }
}
