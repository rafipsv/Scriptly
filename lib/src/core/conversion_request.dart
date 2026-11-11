import 'conversion_options.dart';
import 'language_script.dart';

/// Encapsulates a transliteration request.
class ConversionRequest {
  /// The input text to be converted.
  final String text;

  /// The source language/script.
  final LanguageScript from;

  /// The target language/script.
  final LanguageScript to;

  /// Options governing the conversion.
  final ConversionOptions options;

  /// Creates a [ConversionRequest].
  const ConversionRequest({
    required this.text,
    required this.from,
    required this.to,
    this.options = ConversionOptions.standard,
  });

  @override
  String toString() =>
      'ConversionRequest(text: "$text", from: $from, to: $to, mode: ${options.mode})';
}
