import '../unicode/unicode_utils.dart';
import 'conversion_options.dart';
import 'conversion_request.dart';
import 'conversion_result.dart';
import 'custom_dictionary.dart';
import 'engine_registry.dart';
import 'errors.dart';
import 'language_script.dart';
import 'script_detector.dart';

/// The primary entry point for multi-language, multi-script transliteration.
/// Supports direct engine conversions and automatic pivot routing through Latin.
class Transliterator {
  /// The engine registry used to resolve conversion engines.
  final EngineRegistry registry;

  /// Creates a [Transliterator] with the specified [registry], or defaults if omitted.
  Transliterator({EngineRegistry? registry})
    : registry = registry ?? EngineRegistry.withDefaults();

  /// Converts [text] from [from] language/script to [to] language/script.
  ConversionResult convert(
    String text, {
    required LanguageScript from,
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) {
    if (text.isEmpty) {
      return ConversionResult(
        text: text,
        sourceText: text,
        from: from,
        to: to,
        scheme: 'identity',
      );
    }

    // Canonical Unicode pre-normalization
    final normalized = UnicodeUtils.normalizeCanonical(text);

    // Apply custom dictionary overrides (global + request-specific)
    final preprocessedText = CustomDictionary.apply(
      normalized,
      localOverrides: options.customDictionary,
    );

    if (from == to) {
      return ConversionResult(
        text: preprocessedText,
        sourceText: text,
        from: from,
        to: to,
        scheme: 'identity',
      );
    }

    // Mask technical tokens (URLs, emails) when converting from Latin to non-Latin
    final isMaskingNeeded = from == LanguageScript.latin && to != LanguageScript.latin;
    final urlEmailRegex = RegExp(
      r'(https?:\/\/[^\s]+|www\.[^\s]+|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})',
      caseSensitive: false,
    );

    final placeholders = <String, String>{};
    var maskedText = preprocessedText;
    if (isMaskingNeeded) {
      var maskIndex = 0;
      maskedText = maskedText.replaceAllMapped(urlEmailRegex, (m) {
        final token = m.group(0)!;
        final key = '\uFFF0$maskIndex\uFFF1';
        maskIndex++;
        placeholders[key] = token;
        return key;
      });
    }

    // 1. Try direct engine lookup
    final directEngine = registry.findEngine(from, to);
    if (directEngine != null) {
      final request = ConversionRequest(
        text: maskedText,
        from: from,
        to: to,
        options: options,
      );
      final rawResult = directEngine.convert(request);
      return ConversionResult(
        text: _restorePlaceholders(rawResult.text, placeholders, options, to),
        sourceText: text,
        from: from,
        to: to,
        scheme: rawResult.scheme,
        warnings: rawResult.warnings,
      );
    }

    // 2. Try auto-pivot routing through Latin (Hub-and-Spoke)
    if (from != LanguageScript.latin && to != LanguageScript.latin) {
      final canFromToLatin =
          registry.findEngine(from, LanguageScript.latin) != null;
      final canLatinToTarget =
          registry.findEngine(LanguageScript.latin, to) != null;

      if (canFromToLatin && canLatinToTarget) {
        final step1 = convert(
          maskedText,
          from: from,
          to: LanguageScript.latin,
          options: options,
        );
        final step2 = convert(
          step1.text,
          from: LanguageScript.latin,
          to: to,
          options: options,
        );
        return ConversionResult(
          text: _restorePlaceholders(step2.text, placeholders, options, to),
          sourceText: text,
          from: from,
          to: to,
          scheme: 'pivot-latin (${step1.scheme} -> ${step2.scheme})',
          warnings: [...step1.warnings, ...step2.warnings],
        );
      }
    }

    throw UnsupportedConversionException(from, to);
  }

  static String _restorePlaceholders(
    String text,
    Map<String, String> placeholders,
    ConversionOptions options,
    LanguageScript to,
  ) {
    var result = text;
    if (options.digitPolicy == DigitPolicy.convertToTarget) {
      result = UnicodeUtils.convertAsciiDigitsToScript(result, to);
    }
    if (placeholders.isNotEmpty) {
      for (final entry in placeholders.entries) {
        final val = to.isRtl
            ? UnicodeUtils.wrapBidiIsolates(entry.value, isRtlTarget: true)
            : entry.value;
        result = result.replaceAll(entry.key, val);
      }
    }
    return result;
  }

  /// Automatically detects the source script of [text] and converts it to [to].
  ConversionResult autoConvert(
    String text, {
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) {
    final detection = ScriptDetector.detect(text);
    return convert(
      text,
      from: detection.script,
      to: to,
      options: options,
    );
  }

  /// Checks if a conversion between [from] and [to] is currently supported
  /// either directly or via auto-pivot routing.
  bool canConvert(LanguageScript from, LanguageScript to) {
    if (from == to) return true;
    if (registry.findEngine(from, to) != null) return true;

    // Check pivot feasibility
    if (from != LanguageScript.latin && to != LanguageScript.latin) {
      final hasFromToLatin =
          registry.findEngine(from, LanguageScript.latin) != null;
      final hasLatinToTarget =
          registry.findEngine(LanguageScript.latin, to) != null;
      return hasFromToLatin && hasLatinToTarget;
    }

    return false;
  }
}
