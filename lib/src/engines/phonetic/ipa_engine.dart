import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Transliterator engine converting Latin text to broad International Phonetic Alphabet (IPA).
class IpaEngine implements TransliteratorEngine {
  @override
  String get id => 'ipa-acoustic-engine';

  @override
  String get scheme => 'ipa-broad-transcription';

  @override
  String get version => '0.5.0';

  static const Map<String, String> ipaTable = {
    // Dipthongs & multi-character phonemes
    'sh': 'ʃ', 'ch': 'tʃ', 'jh': 'dʒ', 'th': 'θ', 'dh': 'ð',
    'kh': 'x', 'gh': 'ɣ', 'ng': 'ŋ', 'ny': 'ɲ', 'ph': 'f',
    'bh': 'bʱ', 'aa': 'aː', 'ee': 'iː', 'oo': 'uː', 'ai': 'aɪ',
    'oi': 'ɔɪ', 'ou': 'oʊ', 'au': 'aʊ',
    // Single phonemes
    'a': 'a', 'b': 'b', 'c': 'k', 'd': 'd', 'e': 'e', 'f': 'f',
    'g': 'ɡ', 'h': 'h', 'i': 'i', 'j': 'dʒ', 'k': 'k', 'l': 'l',
    'm': 'm', 'n': 'n', 'o': 'o', 'p': 'p', 'q': 'q', 'r': 'r',
    's': 's', 't': 't', 'u': 'u', 'v': 'v', 'w': 'w', 'x': 'ks',
    'y': 'j', 'z': 'z',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final t = to.normalizedScript;
    final f = from.normalizedScript;
    // Latin <-> IPA (Zyyy)
    if (f == 'Latn' && (t == 'Zyyy' || to.language == 'und')) return true;
    if ((f == 'Zyyy' || from.language == 'und') && t == 'Latn') return true;
    return false;
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isToIpa = request.from.normalizedScript == 'Latn';
    final output = isToIpa ? _toIpa(request.text) : _toLatin(request.text);

    return ConversionResult(
      text: output,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: isToIpa ? scheme : 'ipa-to-latin',
    );
  }

  String _toIpa(String text) {
    final buffer = StringBuffer();
    final len = text.length;
    var index = 0;

    while (index < len) {
      final codeUnit = text.codeUnitAt(index);
      if (codeUnit == 0x20 ||
          codeUnit == 0x09 ||
          codeUnit == 0x0A ||
          (codeUnit >= 0x21 && codeUnit <= 0x2F)) {
        buffer.writeCharCode(codeUnit);
        index++;
        continue;
      }

      String? matchedKey;
      String? matchedVal;

      for (var k = 2; k >= 1; k--) {
        if (index + k <= len) {
          final sub = text.substring(index, index + k).toLowerCase();
          if (ipaTable.containsKey(sub)) {
            matchedKey = sub;
            matchedVal = ipaTable[sub];
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

  String _toLatin(String text) {
    final buffer = StringBuffer();
    final len = text.length;
    var index = 0;

    // Create reverse table sorted by longest IPA string first
    final reverse = <String, String>{};
    for (final e in ipaTable.entries) {
      reverse.putIfAbsent(e.value, () => e.key);
    }

    while (index < len) {
      final codeUnit = text.codeUnitAt(index);
      if (codeUnit == 0x20 ||
          codeUnit == 0x09 ||
          codeUnit == 0x0A ||
          (codeUnit >= 0x21 && codeUnit <= 0x2F)) {
        buffer.writeCharCode(codeUnit);
        index++;
        continue;
      }

      String? matchedKey;
      String? matchedVal;

      for (var k = 3; k >= 1; k--) {
        if (index + k <= len) {
          final sub = text.substring(index, index + k);
          if (reverse.containsKey(sub)) {
            matchedKey = sub;
            matchedVal = reverse[sub];
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
