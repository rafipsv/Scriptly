import 'dart:convert';
import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';

/// Transliterator engine generated dynamically from JSON specifications.
class CustomJsonEngine implements TransliteratorEngine {
  @override
  final String id;

  @override
  final String scheme;

  @override
  final String version;

  final LanguageScript fromScript;
  final LanguageScript toScript;
  final Map<String, String> wordMap;
  final Map<String, String> charMap;

  CustomJsonEngine({
    required this.id,
    required this.scheme,
    this.version = '1.0.0',
    required this.fromScript,
    required this.toScript,
    required this.wordMap,
    required this.charMap,
  });

  /// Factory constructor to parse and create a [CustomJsonEngine] from a JSON string.
  factory CustomJsonEngine.fromJson(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);

    final id = data['id'] as String? ?? 'custom-dynamic-engine';
    final scheme = data['scheme'] as String? ?? 'custom-json-scheme';
    final version = data['version'] as String? ?? '1.0.0';

    final fromCode = data['from'] as String? ?? 'en-Latn';
    final toCode = data['to'] as String? ?? 'custom-Cust';

    final words = (data['words'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        {};

    final rules = (data['rules'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k.toString(), v.toString()),
        ) ??
        {};

    return CustomJsonEngine(
      id: id,
      scheme: scheme,
      version: version,
      fromScript: LanguageScript.fromCode(fromCode),
      toScript: LanguageScript.fromCode(toCode),
      wordMap: words,
      charMap: rules,
    );
  }

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    return from == fromScript && to == toScript;
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    var text = request.text;

    // 1. Word-level replacements (case-insensitive boundary match)
    for (final entry in wordMap.entries) {
      final pattern = RegExp('\\b${RegExp.escape(entry.key)}\\b', caseSensitive: false);
      text = text.replaceAllMapped(pattern, (m) => entry.value);
    }

    // 2. Character / pattern replacements
    if (charMap.isNotEmpty) {
      final buffer = StringBuffer();
      final len = text.length;
      var index = 0;

      while (index < len) {
        String? matchedKey;
        String? matchedVal;

        for (var k = 4; k >= 1; k--) {
          if (index + k <= len) {
            final sub = text.substring(index, index + k);
            if (charMap.containsKey(sub)) {
              matchedKey = sub;
              matchedVal = charMap[sub];
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
      text = buffer.toString();
    }

    return ConversionResult(
      text: text,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }
}
