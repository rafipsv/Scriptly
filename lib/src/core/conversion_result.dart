import 'language_script.dart';

/// The output of a transliteration operation.
class ConversionResult {
  /// The converted text.
  final String text;

  /// The original source text.
  final String sourceText;

  /// The source language/script.
  final LanguageScript from;

  /// The target language/script.
  final LanguageScript to;

  /// The name or identifier of the scheme used (e.g., 'phonetic-avro', 'iso-15919').
  final String scheme;

  /// Non-fatal warnings encountered during conversion (e.g. unmapped sequences).
  final List<String> warnings;

  /// Alternative candidates or suggestions for ambiguous input (optional).
  final List<String> alternatives;

  /// Creates a [ConversionResult].
  const ConversionResult({
    required this.text,
    required this.sourceText,
    required this.from,
    required this.to,
    required this.scheme,
    this.warnings = const [],
    this.alternatives = const [],
  });

  @override
  String toString() =>
      'ConversionResult(text: "$text", scheme: $scheme, warnings: ${warnings.length})';
}
