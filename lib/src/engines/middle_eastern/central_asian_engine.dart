import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Transliterator engine for Kurdish (ku-Arab Hawar ↔ Sorani),
/// Pashto (ps-Arab), and Kazakh (kk-Cyrl ↔ 2021 Latin Standard).
class CentralAsianEngine implements TransliteratorEngine {
  @override
  String get id => 'central-asian-engine';

  @override
  String get scheme => 'hawar-and-kazakh-standard';

  @override
  String get version => '0.5.0';

  static const Map<String, String> commonPhrases = {
    // Kurdish
    'slaw': '\u0633\u06B5\u0627\u0648', // سڵاو
    'spas': '\u0633\u0648\u067E\u0627\u0633', // سوپاس
    'kurd': '\u06A9\u0648\u0631\u062F', // کورد
    'kurdistan': '\u06A9\u0648\u0631\u062F\u0633\u062A\u0627\u0646', // کوردستان

    // Pashto
    'manana': '\u0645\u0646\u0646\u0647', // مننه
    'pakhto': '\u067E\u069A\u062A\u0648', // پښتو
    'afghanistan': '\u0627\u0641\u063A\u0627\u0646\u0633\u062A\u0627\u0646', // افغانستان
    'khe raghlay': '\u069A\u0647 \u0631\u0627\u063A\u0644\u0626', // ښه راغلئ

    // Kazakh
    'sälem': '\u0421\u04D9\u043B\u0435\u043C', // Сәлем
    'salem': '\u0421\u04D9\u043B\u0435\u043C', // Сәлем
    'raqmet': '\u0420\u0430\u049B\u043C\u0435\u0442', // Рақмет
    'qazaqstan': '\u049A\u0430\u0437\u0430\u049B\u0441\u0442\u0430\u043D', // Қазақстан
    'astana': '\u0410\u0441\u0442\u0430\u043D\u0430', // Астана
  };

  static const Map<String, String> kurdishHawarToSorani = {
    'sh': '\u0634', 'ş': '\u0634', 'ch': '\u0686', 'ç': '\u0686',
    'jh': '\u0698', 'j': '\u0698', 'x': '\u062E', 'gh': '\u063A',
    'll': '\u06B5', 'rr': '\u0695', 'ee': '\u06CE', 'ê': '\u06CE',
    'oo': '\u06C6', 'o': '\u06C6', 'u': '\u0648', 'û': '\u0648\u0648',
    'a': '\u0627', 'b': '\u0628', 'c': '\u062C', 'd': '\u062F',
    'e': '\u06D5', 'f': '\u0641', 'g': '\u06AF', 'h': '\u0647',
    'i': '', 'î': '\u06CC', 'k': '\u06A9', 'l': '\u0644',
    'm': '\u0645', 'n': '\u0646', 'p': '\u067E', 'q': '\u0642',
    'r': '\u0631', 's': '\u0633', 't': '\u062A', 'v': '\u06A4',
    'w': '\u0648', 'y': '\u06CC', 'z': '\u0632',
  };

  static const Map<String, String> kazakhCyrToLat = {
    'Ә': 'Ä', 'ә': 'ä', 'Ғ': 'Ğ', 'ғ': 'ğ', 'Қ': 'Q', 'қ': 'q',
    'Ң': 'Ñ', 'ң': 'ñ', 'Ө': 'Ö', 'ө': 'ö', 'Ұ': 'Ū', 'ұ': 'ū',
    'Ү': 'Ü', 'ү': 'ü', 'Һ': 'H', 'һ': 'h', 'Ш': 'Ş', 'ш': 'ş',
    'Ч': 'Ç', 'ч': 'ç', 'Ы': 'Y', 'ы': 'y', 'І': 'İ', 'і': 'i',
    'А': 'A', 'а': 'a', 'Б': 'B', 'б': 'b', 'В': 'V', 'в': 'v',
    'Г': 'G', 'г': 'g', 'Д': 'D', 'д': 'd', 'Е': 'E', 'е': 'e',
    'Ж': 'J', 'ж': 'j', 'З': 'Z', 'з': 'z', 'И': 'I', 'и': 'i',
    'Й': 'I', 'й': 'i', 'К': 'K', 'к': 'k', 'Л': 'L', 'л': 'l',
    'М': 'M', 'м': 'm', 'Н': 'N', 'н': 'n', 'О': 'O', 'о': 'o',
    'П': 'P', 'п': 'p', 'Р': 'R', 'р': 'r', 'С': 'S', 'с': 's',
    'Т': 'T', 'т': 't', 'У': 'U', 'у': 'u', 'Ф': 'F', 'ф': 'f',
    'Х': 'H', 'х': 'h', 'Ц': 'Ts', 'ц': 'ts', 'Щ': 'Ş', 'щ': 'ş',
    'Ъ': '', 'ъ': '', 'Ь': '', 'ь': '', 'Э': 'E', 'э': 'e',
    'Ю': 'Iu', 'ю': 'iu', 'Я': 'Ia', 'я': 'ia',
  };

  static const Map<String, String> kazakhLatToCyr = {
    'Ä': 'Ә', 'ä': 'ә', 'Ğ': 'Ғ', 'ğ': 'ғ', 'Q': 'Қ', 'q': 'қ',
    'Ñ': 'Ң', 'ñ': 'ң', 'Ö': 'Ө', 'ö': 'ө', 'Ū': 'Ұ', 'ū': 'ұ',
    'Ü': 'Ү', 'ü': 'ү', 'Ş': 'Ш', 'ş': 'ш', 'Ç': 'Ч', 'ç': 'ч',
    'Y': 'Ы', 'y': 'ы', 'İ': 'І', 'i': 'і',
    'A': 'А', 'a': 'а', 'B': 'Б', 'b': 'б', 'V': 'В', 'v': 'в',
    'G': 'Г', 'g': 'г', 'D': 'Д', 'd': 'д', 'E': 'Е', 'e': 'е',
    'J': 'Ж', 'j': 'ж', 'Z': 'З', 'z': 'з', 'I': 'И',
    'K': 'К', 'k': 'к', 'L': 'Л', 'l': 'л', 'M': 'М', 'm': 'м',
    'N': 'Н', 'n': 'н', 'O': 'О', 'o': 'о', 'P': 'П', 'p': 'п',
    'R': 'Р', 'r': 'р', 'S': 'С', 's': 'с', 'T': 'Т', 't': 'т',
    'U': 'У', 'u': 'у', 'F': 'Ф', 'f': 'ф', 'H': 'Х', 'h': 'х',
    // ASCII fallbacks
    'ae': 'ә', 'Ae': 'Ә', 'gh': 'ғ', 'Gh': 'Ғ', 'sh': 'ш', 'Sh': 'Ш',
    'ch': 'ч', 'Ch': 'Ч', 'oe': 'ө', 'Oe': 'Ө', 'ue': 'ү', 'Ue': 'Ү',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    const langs = {'ku', 'ps', 'kk'};
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
    final targetLang = isFromLatin ? request.to.normalizedLanguage : request.from.normalizedLanguage;
    final text = request.text;

    final output = isFromLatin
        ? _toNative(text, targetLang)
        : _toLatin(text, targetLang);

    return ConversionResult(
      text: output,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: isFromLatin ? '$targetLang-roman-to-native' : '$targetLang-native-to-roman',
    );
  }

  String _toNative(String input, String targetLang) {
    final lower = input.toLowerCase().trim();
    if (commonPhrases.containsKey(lower)) {
      return commonPhrases[lower]!;
    }

    if (targetLang == 'ku' || targetLang == 'ps') {
      return _replaceLongest(input, kurdishHawarToSorani);
    } else {
      // Kazakh
      return _replaceLongest(input, kazakhLatToCyr);
    }
  }

  String _toLatin(String input, String sourceLang) {
    for (final entry in commonPhrases.entries) {
      if (input.trim() == entry.value) {
        final k = entry.key;
        return k[0].toUpperCase() + k.substring(1);
      }
    }

    if (sourceLang == 'kk') {
      final buffer = StringBuffer();
      for (var i = 0; i < input.length; i++) {
        final ch = input[i];
        buffer.write(kazakhCyrToLat[ch] ?? ch);
      }
      return buffer.toString();
    }

    // Kurdish / Pashto reverse
    final inverted = <String, String>{};
    for (final e in kurdishHawarToSorani.entries) {
      if (e.value.isNotEmpty) {
        inverted.putIfAbsent(e.value, () => e.key);
      }
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
