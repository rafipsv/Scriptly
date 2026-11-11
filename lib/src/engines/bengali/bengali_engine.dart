import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';
import 'banglish_to_bengali.dart';
import 'bengali_to_latin.dart';

/// Pluggable engine providing offline bidirectional transliteration between
/// Bengali script and Latin/Banglish text.
class BengaliEngine implements TransliteratorEngine {
  final BanglishToBengaliConverter _banglishToBengali =
      BanglishToBengaliConverter();
  final BengaliToLatinConverter _bengaliToLatin = BengaliToLatinConverter();

  @override
  String get id => 'bengali-phonetic-engine';

  @override
  String get scheme => 'avro-phonetic-banglish';

  @override
  String get version => '0.1.0';

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final fromScript = from.normalizedScript;
    final toScript = to.normalizedScript;

    // Latin -> Bengali
    if (fromScript == 'Latn' && toScript == 'Beng') {
      return true;
    }

    // Bengali -> Latin
    if (fromScript == 'Beng' && toScript == 'Latn') {
      return true;
    }

    return false;
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final fromScript = request.from.normalizedScript;
    final toScript = request.to.normalizedScript;

    String output;
    String activeScheme;

    if (fromScript == 'Latn' && toScript == 'Beng') {
      output = _banglishToBengali.convert(
        request.text,
        options: request.options,
      );
      activeScheme = 'phonetic-banglish';
    } else if (fromScript == 'Beng' && toScript == 'Latn') {
      output = _bengaliToLatin.convert(request.text, options: request.options);
      activeScheme = 'romanization-latin';
    } else {
      throw UnsupportedConversionException(request.from, request.to);
    }

    return ConversionResult(
      text: output,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: activeScheme,
    );
  }
}
