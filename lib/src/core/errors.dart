import 'language_script.dart';

/// Base class for all polyglot transliterator exceptions.
abstract class TransliteratorException implements Exception {
  /// Description of the error.
  final String message;

  /// Creates a [TransliteratorException].
  const TransliteratorException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when no registered engine supports the requested conversion pair.
class UnsupportedConversionException extends TransliteratorException {
  /// Source language/script.
  final LanguageScript from;

  /// Target language/script.
  final LanguageScript to;

  /// Creates an [UnsupportedConversionException].
  UnsupportedConversionException(this.from, this.to)
    : super('No engine registered to convert from $from to $to.');
}

/// Thrown when invalid options are provided to an engine.
class InvalidConversionOptionsException extends TransliteratorException {
  /// Creates an [InvalidConversionOptionsException].
  const InvalidConversionOptionsException(super.message);
}
