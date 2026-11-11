/// Conversion mode determining the transliteration behavior.
enum ConversionMode {
  /// Phonetic typing mode (e.g., Avro-style Banglish typing).
  phonetic,

  /// Deterministic standard romanization mode.
  romanization,

  /// Strict rule mapping with exact phoneme representation.
  strict,

  /// Permissive rule mapping accepting common colloquial variants.
  permissive,
}

/// Policy for handling digits during conversion.
enum DigitPolicy {
  /// Retains the original script of digits (e.g., keep '123' as '123').
  preserveSource,

  /// Converts digits to the target script (e.g., '123' to Bengali digits).
  convertToTarget,
}

/// Policy for capitalization in target text.
enum CapitalizationPolicy {
  /// Retain capitalization as parsed.
  preserveSource,

  /// Capitalize the first letter of each sentence.
  matchSentenceCase,

  /// Force lowercase output.
  lowerCase,
}

/// Configurable options passed to the transliteration engine.
class ConversionOptions {
  /// The conversion mode.
  final ConversionMode mode;

  /// How digits should be treated.
  final DigitPolicy digitPolicy;

  /// Whether to preserve punctuation characters.
  final bool preservePunctuation;

  /// Whether to preserve spaces, tabs, and line breaks.
  final bool preserveWhitespace;

  /// Whether characters already in the target script should be preserved.
  final bool preserveExistingTargetScript;

  /// Capitalization rule for Latin targets.
  final CapitalizationPolicy capitalizationPolicy;

  /// Creates a [ConversionOptions] configuration.
  const ConversionOptions({
    this.mode = ConversionMode.phonetic,
    this.digitPolicy = DigitPolicy.preserveSource,
    this.preservePunctuation = true,
    this.preserveWhitespace = true,
    this.preserveExistingTargetScript = true,
    this.capitalizationPolicy = CapitalizationPolicy.preserveSource,
  });

  /// Default standard options.
  static const ConversionOptions standard = ConversionOptions();

  /// Default options with target digit conversion enabled.
  static const ConversionOptions withTargetDigits = ConversionOptions(
    digitPolicy: DigitPolicy.convertToTarget,
  );
}
