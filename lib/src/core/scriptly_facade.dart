import 'conversion_options.dart';
import 'conversion_result.dart';
import 'custom_dictionary.dart';
import 'language_script.dart';
import 'phonetic_matcher.dart';
import 'script_detector.dart';
import 'transliterator.dart';

/// Convenient top-level static facade for Scriptly transliteration utilities.
class Scriptly {
  Scriptly._();

  static final Transliterator _defaultTransliterator = Transliterator();

  /// Converts [text] from [from] to [to].
  static ConversionResult convert(
    String text, {
    required LanguageScript from,
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) =>
      _defaultTransliterator.convert(text, from: from, to: to, options: options);

  /// Automatically detects the source script and converts [text] to [to].
  static ConversionResult autoConvert(
    String text, {
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) =>
      _defaultTransliterator.autoConvert(text, to: to, options: options);

  /// Analyzes and detects the primary script of [text].
  static ScriptDetectionResult detect(String text) => ScriptDetector.detect(text);

  /// Calculates cross-script phonetic similarity between [textA] and [textB] (0.0 to 1.0).
  static double similarity(
    String textA,
    String textB, {
    LanguageScript? scriptA,
    LanguageScript? scriptB,
  }) =>
      PhoneticMatcher.similarity(textA, textB, scriptA: scriptA, scriptB: scriptB);

  /// Checks if [query] matches [candidate] within phonetic [threshold] (default 0.70).
  static bool isMatch(
    String query,
    String candidate, {
    double threshold = 0.70,
    LanguageScript? queryScript,
    LanguageScript? candidateScript,
  }) =>
      PhoneticMatcher.isMatch(
        query,
        candidate,
        threshold: threshold,
        queryScript: queryScript,
        candidateScript: candidateScript,
      );

  /// Generates a standardized 4-character phonetic Soundex code.
  static String soundex(String text, {LanguageScript? script}) =>
      PhoneticMatcher.soundex(text, script: script);

  /// Sets or replaces global custom word overrides.
  static void setCustomDictionary(Map<String, String> entries) =>
      CustomDictionary.setGlobal(entries);

  /// Clears global custom word overrides.
  static void clearCustomDictionary() => CustomDictionary.clear();
}
