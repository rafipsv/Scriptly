import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';
import 'arabic_converter.dart';
import 'perso_arabic_constants.dart';
import 'urdu_converter.dart';

/// Transliterator engine supporting Arabic (`ar-Arab`), Urdu (`ur-Arab`), and Persian (`fa-Arab`)
/// bidirectional conversion with Latin, plus direct cross-script Perso-Arabic harmonization.
class PersoArabicEngine implements TransliteratorEngine {
  final ArabicConverter _arabicConverter = ArabicConverter();
  final UrduConverter _urduConverter = UrduConverter();

  @override
  String get id => 'perso-arabic-engine';

  @override
  String get scheme => 'perso-arabic-phonetic';

  @override
  String get version => '0.2.0';

  static const Map<String, String> farsiWords = {
    'salam': '${PersoArabicConstants.seen}${PersoArabicConstants.lam}${PersoArabicConstants.alif}${PersoArabicConstants.meem}',
    'chetori': '${PersoArabicConstants.urduChe}${PersoArabicConstants.tah}${PersoArabicConstants.waw}${PersoArabicConstants.ra}${PersoArabicConstants.urduChhotiYe}',
    'kheyli mamnoon': '${PersoArabicConstants.kha}${PersoArabicConstants.ya}${PersoArabicConstants.lam}${PersoArabicConstants.urduChhotiYe} ${PersoArabicConstants.meem}${PersoArabicConstants.meem}${PersoArabicConstants.noon}${PersoArabicConstants.waw}${PersoArabicConstants.noon}',
    'farsi': '${PersoArabicConstants.fa}${PersoArabicConstants.alif}${PersoArabicConstants.ra}${PersoArabicConstants.seen}${PersoArabicConstants.urduChhotiYe}',
    'khodafez': '${PersoArabicConstants.kha}${PersoArabicConstants.dal}${PersoArabicConstants.alif}${PersoArabicConstants.hha}${PersoArabicConstants.alif}${PersoArabicConstants.fa}${PersoArabicConstants.zah}',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final fLang = from.normalizedLanguage;
    final tLang = to.normalizedLanguage;
    final fScript = from.normalizedScript;
    final tScript = to.normalizedScript;

    // Latin <-> Arabic/Urdu/Persian
    if (fScript == 'Latn' && (tLang == 'ar' || tLang == 'ur' || tLang == 'fa') && tScript == 'Arab') return true;
    if ((fLang == 'ar' || fLang == 'ur' || fLang == 'fa') && fScript == 'Arab' && tScript == 'Latn') return true;

    // Direct Perso-Arabic cross mapping
    if ((fLang == 'ar' || fLang == 'ur' || fLang == 'fa') && (tLang == 'ar' || tLang == 'ur' || tLang == 'fa')) return true;

    return false;
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final fLang = request.from.normalizedLanguage;
    final tLang = request.to.normalizedLanguage;
    final fScript = request.from.normalizedScript;
    final tScript = request.to.normalizedScript;
    final text = request.text;

    String output;
    String activeScheme;

    if (fScript == 'Latn' && tLang == 'fa') {
      output = _farsiFromLatin(text);
      activeScheme = 'finglish-to-persian';
    } else if (fLang == 'fa' && tScript == 'Latn') {
      output = _farsiToLatin(text);
      activeScheme = 'persian-to-finglish';
    } else if (fScript == 'Latn' && tLang == 'ar') {
      output = _arabicConverter.toArabic(text);
      activeScheme = 'arabizi-to-arabic';
    } else if (fLang == 'ar' && tScript == 'Latn') {
      output = _arabicConverter.toLatin(text);
      activeScheme = 'arabic-to-latin';
    } else if (fScript == 'Latn' && tLang == 'ur') {
      output = _urduConverter.toUrdu(text);
      activeScheme = 'roman-to-urdu';
    } else if (fLang == 'ur' && tScript == 'Latn') {
      output = _urduConverter.toLatin(text);
      activeScheme = 'urdu-to-latin';
    } else {
      // Direct Perso-Arabic harmonizer
      output = text;
      if (tLang == 'ur') {
        output = output.replaceAll('\u0643', '\u06A9').replaceAll('\u064A', '\u06CC');
      } else if (tLang == 'ar') {
        output = output.replaceAll('\u06A9', '\u0643').replaceAll('\u06CC', '\u064A');
      }
      activeScheme = '$fLang-to-$tLang-perso-arabic';
    }

    return ConversionResult(
      text: output,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: activeScheme,
    );
  }

  String _farsiFromLatin(String input) {
    final lower = input.toLowerCase().trim();
    if (farsiWords.containsKey(lower)) return farsiWords[lower]!;
    return _urduConverter.toUrdu(input);
  }

  String _farsiToLatin(String input) {
    for (final entry in farsiWords.entries) {
      if (input.trim() == entry.value) {
        return entry.key[0].toUpperCase() + entry.key.substring(1);
      }
    }
    return _urduConverter.toLatin(input);
  }
}
