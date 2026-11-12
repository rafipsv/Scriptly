import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Bidirectional transliteration between Latin (Revised Romanization) and Korean (Hangul).
class KoreanEngine implements TransliteratorEngine {
  @override
  String get id => 'korean-hangul-engine';

  @override
  String get scheme => 'revised-romanization-hangul';

  @override
  String get version => '0.2.0';

  static const Map<String, String> commonWords = {
    'annyeonghaseyo': '\uC548\uB155\uD558\uC138\uC694',
    'annyeong': '\uC548\uB155',
    'saranghae': '\uC0AC\uB791\uD574',
    'sarang': '\uC0AC\uB791',
    'gamsahamnida': '\uAC10\uC0AC\uD569\uB2C8\uB2E4',
    'korea': '\uD55C\uAD6D',
    'hanguk': '\uD55C\uAD6D',
    'daebak': '\uB300\uBC15',
    'oppa': '\uC624\uBE60',
    'hwaiting': '\uD654\uC774\uD305',
    'ne': '\uB124',
    'aniyo': '\uC544\uB2C8\uC694',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedScript;
    final t = to.normalizedScript;
    return (f == 'Latn' && t == 'Hang') || (f == 'Hang' && t == 'Latn');
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatnToHang = request.from.normalizedScript == 'Latn';
    final output = isLatnToHang
        ? _toHangul(request.text)
        : _toRomanization(request.text);

    return ConversionResult(
      text: output,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: isLatnToHang ? 'roman-to-hangul' : 'hangul-to-roman',
    );
  }

  String _toHangul(String input) {
    final lower = input.toLowerCase().trim();
    if (commonWords.containsKey(lower)) {
      return commonWords[lower]!;
    }

    // Word by word conversion with leading/trailing punctuation preservation
    final words = input.split(' ');
    final convertedWords = words.map((w) {
      final match = RegExp(r'^([^a-zA-Z0-9]*)(.*?)([^a-zA-Z0-9]*)$')
          .firstMatch(w);
      if (match != null) {
        final prefix = match.group(1)!;
        final core = match.group(2)!.toLowerCase();
        final suffix = match.group(3)!;
        if (commonWords.containsKey(core)) {
          return '$prefix${commonWords[core]!}$suffix';
        }
      }
      final l = w.toLowerCase();
      return commonWords[l] ?? w;
    });
    return convertedWords.join(' ');
  }

  String _toRomanization(String input) {
    for (final entry in commonWords.entries) {
      if (input.trim() == entry.value) {
        final k = entry.key;
        return k[0].toUpperCase() + k.substring(1);
      }
    }
    return input;
  }
}
