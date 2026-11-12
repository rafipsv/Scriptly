import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';
import 'hinglish_to_hindi.dart';
import 'hindi_to_latin.dart';

/// Transliterator engine supporting Hindi (Devanagari) ↔ Latin (Hinglish).
class HindiEngine implements TransliteratorEngine {
  final HinglishToHindiConverter _hinglishToHindi = HinglishToHindiConverter();
  final HindiToLatinConverter _hindiToLatin = HindiToLatinConverter();

  @override
  String get id => 'hindi-devanagari-engine';

  @override
  String get scheme => 'hinglish-devanagari-phonetic';

  @override
  String get version => '0.1.0';

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedScript;
    final t = to.normalizedScript;
    final isDevaPair =
        (f == 'Latn' && t == 'Deva') || (f == 'Deva' && t == 'Latn');
    if (!isDevaPair) return false;

    final fLang = from.normalizedLanguage;
    final tLang = to.normalizedLanguage;
    // Exclude other specific Devanagari languages: sa, mr, ne
    if (fLang == 'sa' ||
        tLang == 'sa' ||
        fLang == 'mr' ||
        tLang == 'mr' ||
        fLang == 'ne' ||
        tLang == 'ne') {
      return false;
    }
    return true;
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final isLatnToDeva = request.from.normalizedScript == 'Latn';
    final output = isLatnToDeva
        ? _hinglishToHindi.convert(request.text, options: request.options)
        : _hindiToLatin.convert(request.text, options: request.options);

    return ConversionResult(
      text: output,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: isLatnToDeva ? 'hinglish-to-devanagari' : 'devanagari-to-latin',
    );
  }
}
