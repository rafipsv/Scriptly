import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Vietnamese Transliteration Engine supporting standard Telex input method
/// and bidirectional accent removal / Latin romanization.
class VietnameseEngine implements TransliteratorEngine {
  @override
  String get id => 'vietnamese-engine';

  @override
  String get scheme => 'vietnamese-telex-standard';

  @override
  String get version => '0.1.0';

  static const Map<String, String> commonWords = {
    'xin chao': 'Xin chào',
    'cam on': 'Cảm ơn',
    'tam biet': 'Tạm biệt',
    'viet nam': 'Việt Nam',
    'khoe khong': 'Khỏe không',
    'chuc ngu ngon': 'Chúc ngủ ngon',
    'vang': 'Vâng',
    'khong': 'Không',
  };

  static const Map<String, String> telexVowelTransforms = {
    'aa': 'â',
    'Aa': 'Â',
    'AA': 'Â',
    'aw': 'ă',
    'Aw': 'Ă',
    'AW': 'Ă',
    'ee': 'ê',
    'Ee': 'Ê',
    'EE': 'Ê',
    'oo': 'ô',
    'Oo': 'Ô',
    'OO': 'Ô',
    'ow': 'ơ',
    'Ow': 'Ơ',
    'OW': 'Ơ',
    'uw': 'ư',
    'Uw': 'Ư',
    'UW': 'Ư',
    'dd': 'đ',
    'Dd': 'Đ',
    'DD': 'Đ',
  };

  static const Map<String, List<String>> toneTable = {
    // [s, f, r, x, j]
    'a': ['á', 'à', 'ả', 'ã', 'ạ'],
    'A': ['Á', 'À', 'Ả', 'Ã', 'Ạ'],
    'â': ['ấ', 'ầ', 'ẩ', 'ẫ', 'ậ'],
    'Â': ['Ấ', 'Ầ', 'Ẩ', 'Ẫ', 'Ậ'],
    'ă': ['ắ', 'ằ', 'ẳ', 'ẵ', 'ặ'],
    'Ă': ['Ắ', 'Ằ', 'Ẳ', 'Ẵ', 'Ặ'],
    'e': ['é', 'è', 'ẻ', 'ẽ', 'ẹ'],
    'E': ['É', 'È', 'Ẻ', 'Ẽ', 'Ẹ'],
    'ê': ['ế', 'ề', 'ể', 'ễ', 'ệ'],
    'Ê': ['Ế', 'Ề', 'Ể', 'Ễ', 'Ệ'],
    'i': ['í', 'ì', 'ỉ', 'ĩ', 'ị'],
    'I': ['Í', 'Ì', 'Ỉ', 'Ĩ', 'Ị'],
    'o': ['ó', 'ò', 'ỏ', 'õ', 'ọ'],
    'O': ['Ó', 'Ò', 'Ỏ', 'Õ', 'Ọ'],
    'ô': ['ố', 'ồ', 'ổ', 'ỗ', 'ộ'],
    'Ô': ['Ố', 'Ồ', 'Ổ', 'Ỗ', 'Ộ'],
    'ơ': ['ớ', 'ờ', 'ở', 'ỡ', 'ợ'],
    'Ơ': ['Ớ', 'Ờ', 'Ở', 'Ỡ', 'Ợ'],
    'u': ['ú', 'ù', 'ủ', 'ũ', 'ụ'],
    'U': ['Ú', 'Ù', 'Ủ', 'Ũ', 'Ụ'],
    'ư': ['ứ', 'ừ', 'ử', 'ữ', 'ự'],
    'Ư': ['Ứ', 'Ừ', 'Ử', 'Ữ', 'Ự'],
    'y': ['ý', 'ỳ', 'ỷ', 'ỹ', 'ỵ'],
    'Y': ['Ý', 'Ỳ', 'Ỷ', 'Ỹ', 'Ỵ'],
  };

  static const Map<String, int> toneIndices = {
    's': 0, // acute (sắc)
    'f': 1, // grave (huyền)
    'r': 2, // hook above (hỏi)
    'x': 3, // tilde (ngã)
    'j': 4, // dot below (nặng)
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedLanguage;
    final t = to.normalizedLanguage;
    return (f == 'en' && t == 'vi') ||
        (f == 'vi' && t == 'en') ||
        (f == 'vi' && to.normalizedScript == 'Latn');
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatinToVi = request.from.normalizedLanguage == 'en';
    final text = request.text;
    final converted = isLatinToVi ? _telexToVietnamese(text) : _vietnameseToLatin(text);

    return ConversionResult(
      text: converted,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }

  String _telexToVietnamese(String text) {
    if (text.isEmpty) return '';

    var result = text;
    // 1. Replace multi-word common phrases with word boundaries
    for (final entry in commonWords.entries) {
      final pattern = RegExp('\\b${RegExp.escape(entry.key)}\\b', caseSensitive: false);
      result = result.replaceAllMapped(pattern, (m) {
        final matched = m.group(0)!;
        if (matched.isNotEmpty && matched[0] == matched[0].toUpperCase()) {
          return entry.value;
        }
        return entry.value.toLowerCase();
      });
    }

    // 2. Word-by-word tokenization for remaining Telex syllables
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

      final convertedCore = _convertTelexWord(core);
      resultWords.add('$prefix$convertedCore$suffix');
    }

    return resultWords.join(' ');
  }

  String _convertTelexWord(String word) {
    if (word.isEmpty) return '';

    var current = word;

    // 1. Transform basic Telex digraphs
    for (final entry in telexVowelTransforms.entries) {
      current = current.replaceAll(entry.key, entry.value);
    }

    // Handle standalone 'w' -> 'ư'
    current = current.replaceAll('w', 'ư').replaceAll('W', 'Ư');

    // 2. Detect tone keys (s, f, r, x, j) after initial consonant
    if (current.length > 1) {
      int toneCharPos = -1;
      int? foundToneIndex;

      // Search for tone key from right to left (excluding index 0)
      for (int i = current.length - 1; i >= 1; i--) {
        final char = current[i].toLowerCase();
        if (toneIndices.containsKey(char)) {
          toneCharPos = i;
          foundToneIndex = toneIndices[char];
          break;
        }
      }

      if (toneCharPos != -1 && foundToneIndex != null) {
        final stem = current.substring(0, toneCharPos) + current.substring(toneCharPos + 1);

        // Standard Vietnamese tone placement priority:
        // Priority 1: Modified vowels (ê, â, ă, ô, ơ, ư)
        int vowelPos = -1;
        const modifiedVowels = {'ê', 'â', 'ă', 'ô', 'ơ', 'ư', 'Ê', 'Â', 'Ă', 'Ô', 'Ơ', 'Ư'};
        for (int i = 0; i < stem.length; i++) {
          if (modifiedVowels.contains(stem[i])) {
            vowelPos = i;
            break;
          }
        }

        // Priority 2: Primary vowel 'a' (e.g. 'ao' -> 'chào', 'oa' -> 'hoà', 'ai' -> 'bài')
        if (vowelPos == -1) {
          for (int i = 0; i < stem.length; i++) {
            if (stem[i] == 'a' || stem[i] == 'A') {
              vowelPos = i;
              break;
            }
          }
        }

        // Priority 3: Middle/last vowel in diphthongs
        if (vowelPos == -1) {
          for (int i = stem.length - 1; i >= 0; i--) {
            if (toneTable.containsKey(stem[i])) {
              vowelPos = i;
              break;
            }
          }
        }

        if (vowelPos != -1) {
          final vowel = stem[vowelPos];
          final accentedVowel = toneTable[vowel]![foundToneIndex];
          return stem.substring(0, vowelPos) +
              accentedVowel +
              stem.substring(vowelPos + 1);
        }
      }
    }

    return current;
  }

  String _vietnameseToLatin(String text) {
    const accents = {
      'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
      'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
      'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
      'đ': 'd',
      'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
      'ê': 'e', 'ề': 'e', 'ế': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
      'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
      'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
      'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
      'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
      'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
      'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
      'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
      'À': 'A', 'Á': 'A', 'Ả': 'A', 'Ã': 'A', 'Ạ': 'A',
      'Ă': 'A', 'Ằ': 'A', 'Ắ': 'A', 'Ẳ': 'A', 'Ẵ': 'A', 'Ặ': 'A',
      'Â': 'A', 'Ầ': 'A', 'Ấ': 'A', 'Ẩ': 'A', 'Ẫ': 'A', 'Ậ': 'A',
      'Đ': 'D',
      'È': 'E', 'É': 'E', 'Ẻ': 'E', 'Ẽ': 'E', 'Ẹ': 'E',
      'Ê': 'E', 'Ề': 'E', 'Ế': 'E', 'Ể': 'E', 'Ễ': 'E', 'Ệ': 'E',
      'Ì': 'I', 'Í': 'I', 'Ỉ': 'I', 'Ĩ': 'I', 'Ị': 'I',
      'Ò': 'O', 'Ó': 'O', 'Ỏ': 'O', 'Õ': 'O', 'Ọ': 'O',
      'Ô': 'O', 'Ồ': 'O', 'Ố': 'O', 'Ổ': 'O', 'Ỗ': 'O', 'Ộ': 'O',
      'Ơ': 'O', 'Ờ': 'O', 'Ớ': 'O', 'Ở': 'O', 'Ỡ': 'O', 'Ợ': 'O',
      'Ù': 'U', 'Ú': 'U', 'Ủ': 'U', 'Ũ': 'U', 'Ụ': 'U',
      'Ư': 'U', 'Ừ': 'U', 'Ứ': 'U', 'Ử': 'U', 'Ữ': 'U', 'Ự': 'U',
      'Ỳ': 'Y', 'Ý': 'Y', 'Ỷ': 'Y', 'Ỹ': 'Y', 'Ỵ': 'Y',
    };

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      buffer.write(accents[char] ?? char);
    }
    return buffer.toString();
  }
}
