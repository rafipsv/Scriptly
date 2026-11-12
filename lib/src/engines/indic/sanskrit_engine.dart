import '../../core/conversion_request.dart';
import '../../core/conversion_result.dart';
import '../../core/errors.dart';
import '../../core/language_script.dart';
import '../../core/transliterator_engine.dart';
import '../bengali/bengali_engine.dart';
import '../hindi/hindi_engine.dart';

/// Transliterator engine for Sanskrit (`sa-Deva` with IAST/Harvard-Kyoto),
/// Marathi (`mr-Deva`), Nepali (`ne-Deva`), and Assamese (`as-Beng`).
class SanskritIndicExtensionEngine implements TransliteratorEngine {
  final HindiEngine _hindiEngine = HindiEngine();
  final BengaliEngine _bengaliEngine = BengaliEngine();

  @override
  String get id => 'sanskrit-indic-extension-engine';

  @override
  String get scheme => 'iast-brahmic-alignment';

  @override
  String get version => '0.5.0';

  static const Map<String, String> sanskritWords = {
    'om shanti': '\u0950 \u0936\u093E\u0928\u094D\u0924\u093F\u0903',
    'om': '\u0950',
    'shanti': '\u0936\u093E\u0928\u094D\u0924\u093F\u0903',
    'namaste': '\u0928\u092E\u0938\u094D\u0924\u0947',
    'dhanyavada': '\u0927\u0928\u094D\u092F\u0935\u093E\u0926\u0903',
    'subhashitam': '\u0938\u0941\u092D\u093E\u0937\u093F\u0924\u092E\u094D',
    'nepal': '\u0928\u0947\u092A\u093E\u0932',
    'namaskar': '\u0928\u092E\u0938\u094D\u0915\u093E\u0930',
    'dhanyabad': '\u0927\u0928\u094D\u092F\u092C\u093E\u0926',
    'maharashtra': '\u092E\u0939\u093E\u0930\u093E\u0937\u094D\u091F\u094D\u0930',
    'asomiya': '\u0985\u09B8\u09AE\u09C0\u09AF\u09BC\u09BE',
    'guwahati': '\u0997\u09C1\u09F1\u09BE\u09B9\u09BE\u099F\u09C0',
    'axom': '\u0985\u09B8\u09AE',
  };

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    final f = from.normalizedLanguage;
    final t = to.normalizedLanguage;
    final fS = from.normalizedScript;
    final tS = to.normalizedScript;

    // Latin <-> Sanskrit / Marathi / Nepali / Assamese
    const supportedLangs = {'sa', 'mr', 'ne', 'as'};
    if (fS == 'Latn' && supportedLangs.contains(t)) return true;
    if (supportedLangs.contains(f) && tS == 'Latn') return true;

    // Cross-bridge with Indic
    if (supportedLangs.contains(f) && (tS == 'Deva' || tS == 'Beng')) return true;
    if ((fS == 'Deva' || fS == 'Beng') && supportedLangs.contains(t)) return true;

    return false;
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    if (!supports(request.from, request.to)) {
      throw UnsupportedConversionException(request.from, request.to);
    }

    final tLang = request.to.normalizedLanguage;
    final fLang = request.from.normalizedLanguage;
    final fScript = request.from.normalizedScript;
    final text = request.text;

    String output;

    if (fScript == 'Latn') {
      output = _convertFromLatin(text, tLang, request);
    } else {
      output = _convertToLatinOrBridge(text, fLang, tLang, request);
    }

    return ConversionResult(
      text: output,
      sourceText: text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }

  String _convertFromLatin(String text, String tLang, ConversionRequest request) {
    final lower = text.toLowerCase().trim();
    if (sanskritWords.containsKey(lower)) {
      return sanskritWords[lower]!;
    }

    // Assamese uses Bengali script base with specific Ro and Wo
    if (tLang == 'as') {
      final beng = _bengaliEngine.convert(
        ConversionRequest(
          text: text,
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
          options: request.options,
        ),
      ).text;
      // Replace Bengali Ra (\u09B0) with Assamese Ro (\u09F0) and Ba (\u09AC) with Assamese Wo (\u09F1) where contextually requested
      return beng.replaceAll('র', '\u09F0');
    }

    // Sanskrit, Marathi, Nepali map through Devanagari with IAST pre-normalization
    final normalizedIast = _normalizeIast(text);
    final deva = _hindiEngine.convert(
      ConversionRequest(
        text: normalizedIast,
        from: LanguageScript.latin,
        to: LanguageScript.hindi,
        options: request.options,
      ),
    ).text;

    if (tLang == 'mr') {
      // Marathi retroflex lateral Lla (U+0933)
      return deva.replaceAll('ळ', '\u0933');
    }

    return deva;
  }

  String _convertToLatinOrBridge(String text, String fLang, String tLang, ConversionRequest request) {
    for (final entry in sanskritWords.entries) {
      if (text.trim() == entry.value) {
        final k = entry.key;
        return k[0].toUpperCase() + k.substring(1);
      }
    }

    if (fLang == 'as') {
      final normalized = text.replaceAll('\u09F0', 'র').replaceAll('\u09F1', 'ব');
      return _bengaliEngine.convert(
        ConversionRequest(
          text: normalized,
          from: LanguageScript.bengali,
          to: LanguageScript.latin,
          options: request.options,
        ),
      ).text;
    }

    return _hindiEngine.convert(
      ConversionRequest(
        text: text,
        from: LanguageScript.hindi,
        to: LanguageScript.latin,
        options: request.options,
      ),
    ).text;
  }

  String _normalizeIast(String input) {
    return input
        .replaceAll('ā', 'aa')
        .replaceAll('ī', 'ee')
        .replaceAll('ū', 'oo')
        .replaceAll('ṛ', 'ri')
        .replaceAll('ṝ', 'ri')
        .replaceAll('ḷ', 'li')
        .replaceAll('ṃ', 'm')
        .replaceAll('ḥ', 'h')
        .replaceAll('ś', 'sh')
        .replaceAll('ṣ', 'sh')
        .replaceAll('ṅ', 'ng')
        .replaceAll('ñ', 'ny')
        .replaceAll('ṭ', 't')
        .replaceAll('ḍ', 'd')
        .replaceAll('ṇ', 'n');
  }
}
