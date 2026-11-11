import 'conversion_options.dart';
import 'conversion_request.dart';
import 'conversion_result.dart';
import 'engine_registry.dart';
import 'errors.dart';
import 'language_script.dart';

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
    if (from == to || text.isEmpty) {
      return ConversionResult(
        text: text,
        sourceText: text,
        from: from,
        to: to,
        scheme: 'identity',
      );
    }

    // 1. Try direct engine lookup
    final directEngine = registry.findEngine(from, to);
    if (directEngine != null) {
      final request = ConversionRequest(
        text: text,
        from: from,
        to: to,
        options: options,
      );
      return directEngine.convert(request);
    }

    // 2. Try auto-pivot routing through Latin (Hub-and-Spoke)
    if (from != LanguageScript.latin && to != LanguageScript.latin) {
      final canFromToLatin =
          registry.findEngine(from, LanguageScript.latin) != null;
      final canLatinToTarget =
          registry.findEngine(LanguageScript.latin, to) != null;

      if (canFromToLatin && canLatinToTarget) {
        final step1 = convert(
          text,
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
          text: step2.text,
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
