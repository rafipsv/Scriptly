import '../engines/custom/custom_json_engine.dart';
import '../pipeline/markdown_transliterator.dart';
import '../pipeline/scriptly_stream_transformer.dart';
import '../security/identity_hasher.dart';
import '../security/pii_shield.dart';
import '../unicode/punctuation_harmonizer.dart';
import 'conversion_options.dart';
import 'conversion_result.dart';
import 'custom_dictionary.dart';
import 'frequency_trie.dart';
import 'language_script.dart';
import 'phonetic_matcher.dart';
import 'script_detector.dart';
import 'transliterator.dart';

/// Convenient top-level static facade for Scriptly transliteration utilities.
class Scriptly {
  Scriptly._();

  static final Transliterator _defaultTransliterator = Transliterator();
  static final FrequencyTrie _defaultFrequencyTrie =
      FrequencyTrie.withDefaults();

  /// Default registry used by the static facade.
  static Transliterator get defaultTransliterator => _defaultTransliterator;

  /// Default frequency trie for word candidate ranking.
  static FrequencyTrie get defaultFrequencyTrie => _defaultFrequencyTrie;

  /// Converts [text] from [from] to [to].
  static ConversionResult convert(
    String text, {
    required LanguageScript from,
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) => _defaultTransliterator.convert(
    text,
    from: from,
    to: to,
    options: options,
  );

  /// Asynchronously converts [text] from [from] to [to] without blocking the main event loop.
  static Future<ConversionResult> convertAsync(
    String text, {
    required LanguageScript from,
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) {
    return Future<ConversionResult>(() {
      return convert(text, from: from, to: to, options: options);
    });
  }

  /// Automatically detects the source script and converts [text] to [to].
  static ConversionResult autoConvert(
    String text, {
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) => _defaultTransliterator.autoConvert(text, to: to, options: options);

  /// Asynchronously detects the source script and converts [text] to [to].
  static Future<ConversionResult> autoConvertAsync(
    String text, {
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) {
    return Future<ConversionResult>(() {
      return autoConvert(text, to: to, options: options);
    });
  }

  /// Transliterates human text in Markdown documents while preserving code blocks, URLs, and HTML.
  static String convertMarkdown(
    String markdown, {
    required LanguageScript from,
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) {
    return MarkdownTransliterator(transliterator: _defaultTransliterator)
        .convert(markdown, from: from, to: to, options: options);
  }

  /// Creates a streaming [ScriptlyStreamTransformer] for real-time streams or large files.
  static ScriptlyStreamTransformer streamTransformer({
    required LanguageScript from,
    required LanguageScript to,
    ConversionOptions options = ConversionOptions.standard,
  }) {
    return ScriptlyStreamTransformer(
      from: from,
      to: to,
      options: options,
      transliterator: _defaultTransliterator,
    );
  }

  /// Computes a canonical deterministic phonetic identity hash for entity deduplication / KYC.
  static String identityHash(String name) => PhoneticIdentityHasher.hash(name);

  /// Checks if two names resolve to the same canonical phonetic identity.
  static bool isSameIdentity(String name1, String name2) =>
      PhoneticIdentityHasher.isSameIdentity(name1, name2);

  /// Shields sensitive PII (credit cards, emails, phones, OTPs) with safe tokens.
  static PiiShieldResult shieldPii(String input) => PiiShield.shield(input);

  /// Restores shielded tokens in [text] using [tokens] mapping.
  static String restorePii(String text, Map<String, String> tokens) =>
      PiiShield.restore(text, tokens);

  /// Adapts standard ASCII punctuation to target script conventions (e.g. Indic Dari, Arabic comma).
  static String harmonizePunctuation(
    String text,
    LanguageScript targetScript,
  ) => PunctuationHarmonizer.harmonize(text, targetScript);

  /// Registers a custom language engine dynamically parsed from a [jsonString].
  static void registerCustomLanguageFromJson(String jsonString) {
    final engine = CustomJsonEngine.fromJson(jsonString);
    _defaultTransliterator.registry.register(engine);
  }

  /// Analyzes and detects the primary script of [text].
  static ScriptDetectionResult detect(String text) =>
      ScriptDetector.detect(text);

  /// Calculates cross-script phonetic similarity between [textA] and [textB] (0.0 to 1.0).
  static double similarity(
    String textA,
    String textB, {
    LanguageScript? scriptA,
    LanguageScript? scriptB,
  }) => PhoneticMatcher.similarity(
    textA,
    textB,
    scriptA: scriptA,
    scriptB: scriptB,
  );

  /// Checks if [query] matches [candidate] within phonetic [threshold] (default 0.70).
  static bool isMatch(
    String query,
    String candidate, {
    double threshold = 0.70,
    LanguageScript? queryScript,
    LanguageScript? candidateScript,
  }) => PhoneticMatcher.isMatch(
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
