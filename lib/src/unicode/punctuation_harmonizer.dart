import '../core/language_script.dart';

/// Harmonizes ASCII and Latin punctuation marks into target script-native
/// punctuation (e.g. Indic Dari '।', Arabic comma '،', Greek question mark ';').
class PunctuationHarmonizer {
  PunctuationHarmonizer._();

  /// Adapts standard ASCII punctuation in [text] to the native conventions of [targetScript].
  static String harmonize(String text, LanguageScript targetScript) {
    if (text.isEmpty) return text;

    var result = text;

    // 1. Indic Scripts: Period -> Dari
    if (_isIndicScript(targetScript)) {
      result = result.replaceAll('..', '\u0965'); // Double Dari
      result = result.replaceAll(
        RegExp(r'(?<=\w|\s)\.(?!\w)'),
        '\u0964',
      ); // Single Dari
    }
    // 2. Perso-Arabic Scripts: Arabic comma, question mark, semicolon
    else if (_isPersoArabic(targetScript)) {
      result = result.replaceAll('?', '\u061F'); // Arabic Question Mark
      result = result.replaceAll(',', '\u060C'); // Arabic Comma
      result = result.replaceAll(';', '\u061B'); // Arabic Semicolon
    }
    // 3. Greek: Question mark -> Greek question mark ';'
    else if (targetScript == LanguageScript.greek) {
      result = result.replaceAll('?', '\u037E'); // Greek question mark
    }
    // 4. East Asian (Japanese, Chinese): Ideographic comma & full stop
    else if (targetScript == LanguageScript.japanese ||
        targetScript == LanguageScript.chinesePinyin) {
      result = result.replaceAll(
        RegExp(r'\.(?!\w)'),
        '\u3002',
      ); // Ideographic full stop
      result = result.replaceAll(',', '\uFF0C'); // Fullwidth comma
    }

    return result;
  }

  static bool _isIndicScript(LanguageScript script) {
    return script == LanguageScript.bengali ||
        script == LanguageScript.hindi ||
        script == LanguageScript.sanskrit ||
        script == LanguageScript.marathi ||
        script == LanguageScript.nepali ||
        script == LanguageScript.assamese ||
        script == LanguageScript.gujarati ||
        script == LanguageScript.punjabi ||
        script == LanguageScript.odia;
  }

  static bool _isPersoArabic(LanguageScript script) {
    return script == LanguageScript.arabic ||
        script == LanguageScript.urdu ||
        script == LanguageScript.persian ||
        script == LanguageScript.kurdish ||
        script == LanguageScript.pashto;
  }
}
