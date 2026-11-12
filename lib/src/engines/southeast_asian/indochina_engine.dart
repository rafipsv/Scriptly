import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Transliterator engine for Indochina writing systems:
/// Lao (lo-Laoo UNGEGN), Burmese (my-Mymr MLC/ISO 11940), and Khmer (km-Khmr UNGEGN).
class IndochinaEngine implements TransliteratorEngine {
  @override
  String get id => 'indochina-engine';

  @override
  String get scheme => 'ungegn-indochina-matrix';

  @override
  String get version => '0.5.0';

  static const Map<String, String> commonPhrases = {
    // Lao
    'sabaidee': '\u0EAA\u0EB0\u0E9A\u0EB2\u0E8D\u0E94\u0EB5', // ສະບາຍດີ
    'khop jai': '\u0E82\u0EAD\u0E9A\u0EC3\u0E88', // ຂອບໃຈ
    'vientiane': '\u0EA7\u0EBD\u0E87\u0E88\u0EB1\u0E99', // ວຽງຈັນ
    'laos': '\u0EA5\u0EB2\u0EA7', // ລາວ
    // Burmese
    'mingalaba':
        '\u1019\u1004\u103A\u1039\u1002\u101C\u102C\u1015\u102B', // မင်္ဂလာပါ
    'kyay zu': '\u1000\u103B\u1038\u1007\u1038',
    'yangon': '\u101B\u1014\u103A\u1000\u102F\u1014\u103A', // ရန်ကုန်
    'myanmar': '\u1019\u103C\u1014\u103A\u1019\u102C', // မြန်မာ
    // Khmer
    'suesdei': '\u179f\u17bd\u179f\u17d2\u178f\u17b8', // សួស្តី
    'suesdey': '\u179f\u17bd\u179f\u17d2\u178f\u17b8', // សួស្តី
    'arkun': '\u17a2\u179a\u1782\u17bb\u178e', // អរគុណ
    'phnom penh': '\u1797\u17d2\u1793\u17c6\u1796\u17c1\u1789', // ភ្នំពេញ
    'cambodia': '\u1780\u1798\u17d2\u1796\u17bb\u1787\u17b8', // កម្ពុជា
  };

  static const Map<String, String> laoConsonants = {
    'kh': '\u0E82',
    'ng': '\u0E87',
    'ch': '\u0E88',
    'ny': '\u0E8D',
    'th': '\u0E97',
    'ph': '\u0E9E',
    'k': '\u0E81',
    's': '\u0EAA',
    'd': '\u0E94',
    't': '\u0E95',
    'n': '\u0E99',
    'b': '\u0E9A',
    'p': '\u0E9B',
    'f': '\u0E9F',
    'm': '\u0EA1',
    'y': '\u0EA2',
    'r': '\u0EA3',
    'l': '\u0EA5',
    'w': '\u0EA7',
    'v': '\u0EA7',
    'h': '\u0EAE',
    'a': '\u0EB0',
    'aa': '\u0EB2',
    'i': '\u0EB4',
    'ii': '\u0EB5',
    'u': '\u0EB8',
    'uu': '\u0EB9',
    'o': '\u0EC2',
  };

  static const Map<String, String> burmeseConsonants = {
    'kh': '\u1001',
    'ng': '\u1004',
    'ch': '\u1006',
    'ny': '\u1009',
    'th': '\u101E',
    'ht': '\u1011',
    'hp': '\u1015',
    'sh': '\u103E',
    'k': '\u1000',
    'g': '\u1002',
    's': '\u1005',
    'z': '\u1007',
    't': '\u1010',
    'd': '\u1012',
    'n': '\u1014',
    'p': '\u1015',
    'b': '\u1017',
    'm': '\u1019',
    'y': '\u101A',
    'r': '\u101B',
    'l': '\u101C',
    'w': '\u101D',
    'h': '\u101F',
    'a': '\u1021',
  };

  static const Map<String, String> khmerConsonants = {
    'kh': '\u1781',
    'ng': '\u1784',
    'ch': '\u1785',
    'chh': '\u1786',
    'nh': '\u1789',
    'th': '\u1790',
    'ph': '\u1795',
    'k': '\u1780',
    'g': '\u1782',
    's': '\u179f',
    'd': '\u178a',
    't': '\u178f',
    'n': '\u1793',
    'b': '\u1794',
    'p': '\u1796',
    'm': '\u1798',
    'y': '\u1799',
    'r': '\u179a',
    'l': '\u179b',
    'v': '\u179c',
    'h': '\u17a0',
    'a': '\u17a2',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    const langs = {'lo', 'my', 'km'};
    final f = from.normalizedLanguage;
    final t = to.normalizedLanguage;
    final fS = from.normalizedScript;
    final tS = to.normalizedScript;

    if (fS == 'Latn' && langs.contains(t)) return true;
    if (langs.contains(f) && tS == 'Latn') return true;
    return false;
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isFromLatin = request.from.normalizedScript == 'Latn';
    final targetLang = isFromLatin
        ? request.to.normalizedLanguage
        : request.from.normalizedLanguage;
    final text = request.text;

    final output = isFromLatin
        ? _toIndochina(text, targetLang)
        : _toLatin(text, targetLang);

    return ConversionResult(
      text: output,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: isFromLatin
          ? '$targetLang-roman-to-native'
          : '$targetLang-native-to-roman',
    );
  }

  String _toIndochina(String input, String targetLang) {
    final lower = input.toLowerCase().trim();
    if (commonPhrases.containsKey(lower)) {
      return commonPhrases[lower]!;
    }

    final map = targetLang == 'lo'
        ? laoConsonants
        : (targetLang == 'my' ? burmeseConsonants : khmerConsonants);

    return _replaceLongest(input, map);
  }

  String _toLatin(String input, String sourceLang) {
    final cleanInput = sourceLang == 'my'
        ? input.replaceAll('\u102B', '\u102C').trim()
        : input.trim();

    for (final entry in commonPhrases.entries) {
      final target = sourceLang == 'my'
          ? entry.value.replaceAll('\u102B', '\u102C').trim()
          : entry.value.trim();
      if (cleanInput == target) {
        final k = entry.key;
        return k[0].toUpperCase() + k.substring(1);
      }
    }

    final map = sourceLang == 'lo'
        ? laoConsonants
        : (sourceLang == 'my' ? burmeseConsonants : khmerConsonants);

    // Invert mapping
    final inverted = <String, String>{};
    for (final e in map.entries) {
      inverted.putIfAbsent(e.value, () => e.key);
    }

    return _replaceLongest(input, inverted);
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
          final sub = text.substring(index, index + k).toLowerCase();
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
