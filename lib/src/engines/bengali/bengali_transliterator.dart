import '../../core/conversion_options.dart';
import '../../core/conversion_request.dart';
import '../../core/language_script.dart';
import 'bengali_engine.dart';

/// Ergonomic convenience wrapper specifically for Bengali ↔ Latin transliteration.
class BengaliTransliterator {
  final BengaliEngine _engine;

  /// Creates a [BengaliTransliterator] instance.
  BengaliTransliterator({BengaliEngine? engine})
    : _engine = engine ?? BengaliEngine();

  /// Converts Latin/Banglish phonetic text to Bengali script.
  String toBengali(
    String banglish, {
    ConversionOptions options = ConversionOptions.standard,
  }) {
    final result = _engine.convert(
      ConversionRequest(
        text: banglish,
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
        options: options,
      ),
    );
    return result.text;
  }

  /// Converts Bengali script to Latin romanization.
  String toLatin(
    String bengali, {
    ConversionOptions options = ConversionOptions.standard,
  }) {
    final result = _engine.convert(
      ConversionRequest(
        text: bengali,
        from: LanguageScript.bengali,
        to: LanguageScript.latin,
        options: options,
      ),
    );
    return result.text;
  }
}
