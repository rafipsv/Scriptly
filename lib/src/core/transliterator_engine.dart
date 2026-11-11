import 'conversion_request.dart';
import 'conversion_result.dart';
import 'language_script.dart';

/// Abstract contract for a pluggable transliteration engine.
abstract class TransliteratorEngine {
  /// Unique identifier of the engine (e.g., 'bengali-rule-engine').
  String get id;

  /// Identifier of the transliteration scheme implemented (e.g., 'phonetic-banglish').
  String get scheme;

  /// Semantic version of this engine's rule set (e.g., '1.0.0').
  String get version;

  /// Returns whether this engine can convert between [from] and [to].
  bool supports(LanguageScript from, LanguageScript to);

  /// Performs conversion for the given [request].
  ConversionResult convert(ConversionRequest request);
}
