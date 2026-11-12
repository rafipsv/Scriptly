import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Bidirectional transliteration between Latin (Romaji) and Japanese script (Hiragana/Katakana).
class JapaneseEngine implements TransliteratorEngine {
  @override
  String get id => 'japanese-kana-engine';

  @override
  String get scheme => 'hepburn-hiragana-katakana';

  @override
  String get version => '0.2.0';

  static const Map<String, String> commonWords = {
    'arigatou': '\u3042\u308A\u304C\u3068\u3046',
    'arigato': '\u3042\u308A\u304C\u3068\u3046',
    'konnichiwa': '\u3053\u3093\u306B\u3061\u306F',
    'sayonara': '\u3055\u3088\u3046\u306A\u3089',
    'sumimasen': '\u3059\u307F\u307E\u305B\u3093',
    'ohayou': '\u304A\u306F\u3088\u3046',
    'hai': '\u306F\u3044',
    'iie': '\u3044\u3044\u3048',
    'nihon': '\u306B\u307B\u3093',
    'tokyo': '\u3068\u3046\u304D\u3087\u3046',
  };

  static const Map<String, String> romajiToHiragana = {
    'kya': '\u304D\u3083',
    'kyu': '\u304D\u3085',
    'kyo': '\u304D\u3087',
    'sha': '\u3057\u3083',
    'shu': '\u3057\u3085',
    'sho': '\u3057\u3087',
    'cha': '\u3061\u3083',
    'chu': '\u3061\u3085',
    'cho': '\u3061\u3087',
    'nya': '\u306B\u3083',
    'nyu': '\u306B\u3085',
    'nyo': '\u306B\u3087',
    'hya': '\u3072\u3083',
    'hyu': '\u3072\u3085',
    'hyo': '\u3072\u3087',
    'mya': '\u307F\u3083',
    'myu': '\u307F\u3085',
    'myo': '\u307F\u3087',
    'rya': '\u308A\u3083',
    'ryu': '\u308A\u3085',
    'ryo': '\u308A\u3087',
    'gya': '\u304E\u3083',
    'gyu': '\u304E\u3085',
    'gyo': '\u304E\u3087',
    'bya': '\u3073\u3083',
    'byu': '\u3073\u3085',
    'byo': '\u3073\u3087',
    'pya': '\u3074\u3083',
    'pyu': '\u3074\u3085',
    'pyo': '\u3074\u3087',
    'ka': '\u304B',
    'ki': '\u304D',
    'ku': '\u304F',
    'ke': '\u3051',
    'ko': '\u3053',
    'sa': '\u3055',
    'shi': '\u3057',
    'su': '\u3059',
    'se': '\u305B',
    'so': '\u305D',
    'ta': '\u305F',
    'chi': '\u3061',
    'tsu': '\u3064',
    'te': '\u3066',
    'to': '\u3068',
    'na': '\u306A',
    'ni': '\u306B',
    'nu': '\u306C',
    'ne': '\u306D',
    'no': '\u306E',
    'ha': '\u306F',
    'hi': '\u3072',
    'fu': '\u3075',
    'he': '\u3078',
    'ho': '\u307B',
    'ma': '\u307E',
    'mi': '\u307F',
    'mu': '\u3080',
    'me': '\u3081',
    'mo': '\u3082',
    'ya': '\u3084',
    'yu': '\u3086',
    'yo': '\u3088',
    'ra': '\u3089',
    'ri': '\u308A',
    'ru': '\u308B',
    're': '\u308C',
    'ro': '\u308D',
    'wa': '\u308F',
    'wo': '\u3092',
    'nn': '\u3093',
    'ga': '\u304C',
    'gi': '\u304E',
    'gu': '\u3042',
    'ge': '\u3052',
    'go': '\u3054',
    'za': '\u3056',
    'ji': '\u3058',
    'zu': '\u305A',
    'ze': '\u305C',
    'zo': '\u305E',
    'da': '\u3060',
    'de': '\u3067',
    'do': '\u3068',
    'ba': '\u3070',
    'bi': '\u3073',
    'bu': '\u3074',
    'be': '\u3076',
    'bo': '\u3078',
    'pa': '\u3071',
    'pi': '\u3074',
    'pu': '\u3077',
    'pe': '\u307A',
    'po': '\u307D',
    'a': '\u3042',
    'i': '\u3044',
    'u': '\u3046',
    'e': '\u3048',
    'o': '\u304A',
    'n': '\u3093',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedScript;
    final t = to.normalizedScript;
    return (f == 'Latn' && t == 'Jpan') || (f == 'Jpan' && t == 'Latn');
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatnToJpan = request.from.normalizedScript == 'Latn';
    final output = isLatnToJpan
        ? _toKana(request.text)
        : _toRomaji(request.text);

    return ConversionResult(
      text: output,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: isLatnToJpan ? 'romaji-to-hiragana' : 'kana-to-romaji',
    );
  }

  String _toKana(String input) {
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

      // Check double consonants (sokuon - small tsu: \u3063)
      if (index + 1 < len &&
          input[index] == input[index + 1] &&
          input[index] != 'n' &&
          RegExp(r'[a-z]').hasMatch(input[index])) {
        buffer.write('\u3063'); // Small Tsu
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

  String _toRomaji(String input) {
    for (final entry in commonWords.entries) {
      if (input.trim() == entry.value) {
        final k = entry.key;
        return k[0].toUpperCase() + k.substring(1);
      }
    }

    final buffer = StringBuffer();
    for (final entry in romajiToHiragana.entries) {
      if (input.contains(entry.value)) {
        input = input.replaceAll(entry.value, entry.key);
      }
    }
    buffer.write(input);
    return buffer.toString();
  }

  MapEntry<String, String>? _matchLongest(String text, int start) {
    final rem = text.substring(start).toLowerCase();
    for (var len = 3; len >= 1; len--) {
      if (rem.length >= len) {
        final sub = rem.substring(0, len);
        if (romajiToHiragana.containsKey(sub)) {
          return MapEntry(sub, romajiToHiragana[sub]!);
        }
      }
    }
    return null;
  }
}
