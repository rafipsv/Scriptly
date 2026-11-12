/// Represents a language and script pair following BCP-47 and ISO 15924 standards.
class LanguageScript {
  /// BCP-47 language tag (e.g. 'bn', 'en', 'hi', 'ur', 'ar', 'gu', 'ta', 'te', 'pa', 'ml', 'ja', 'ko', 'zh', 'fa', 'he', 'ru', 'el').
  final String language;

  /// ISO 15924 script tag (e.g. 'Beng', 'Latn', 'Deva', 'Arab', 'Gujr', 'Taml', 'Telu', 'Guru', 'Mlym', 'Jpan', 'Hang', 'Hebr', 'Cyrl', 'Grek').
  final String script;

  /// Creates a [LanguageScript] instance.
  const LanguageScript(this.language, this.script);

  // --- Core Group ---
  static const LanguageScript bengali = LanguageScript('bn', 'Beng');
  static const LanguageScript latin = LanguageScript('en', 'Latn');
  static const LanguageScript hindi = LanguageScript('hi', 'Deva');
  static const LanguageScript urdu = LanguageScript('ur', 'Arab');
  static const LanguageScript arabic = LanguageScript('ar', 'Arab');

  // --- Indic Group ---
  static const LanguageScript gujarati = LanguageScript('gu', 'Gujr');
  static const LanguageScript tamil = LanguageScript('ta', 'Taml');
  static const LanguageScript telugu = LanguageScript('te', 'Telu');
  static const LanguageScript punjabi = LanguageScript('pa', 'Guru');
  static const LanguageScript malayalam = LanguageScript('ml', 'Mlym');
  static const LanguageScript kannada = LanguageScript('kn', 'Knda');
  static const LanguageScript odia = LanguageScript('or', 'Orya');
  static const LanguageScript sinhala = LanguageScript('si', 'Sinh');

  // --- Southeast Asian Group ---
  static const LanguageScript vietnamese = LanguageScript('vi', 'Latn');
  static const LanguageScript thai = LanguageScript('th', 'Thai');

  // --- East Asian Group ---
  static const LanguageScript japanese = LanguageScript('ja', 'Jpan');
  static const LanguageScript korean = LanguageScript('ko', 'Hang');
  static const LanguageScript chinesePinyin = LanguageScript('zh', 'Latn');

  // --- Middle Eastern Group ---
  static const LanguageScript persian = LanguageScript('fa', 'Arab');
  static const LanguageScript hebrew = LanguageScript('he', 'Hebr');

  // --- European / Slavic Group ---
  static const LanguageScript russian = LanguageScript('ru', 'Cyrl');
  static const LanguageScript ukrainian = LanguageScript('uk', 'Cyrl');
  static const LanguageScript serbian = LanguageScript('sr', 'Cyrl');
  static const LanguageScript bulgarian = LanguageScript('bg', 'Cyrl');
  static const LanguageScript macedonian = LanguageScript('mk', 'Cyrl');
  static const LanguageScript belarusian = LanguageScript('be', 'Cyrl');
  static const LanguageScript greek = LanguageScript('el', 'Grek');

  // --- Caucasus & World Group ---
  static const LanguageScript georgian = LanguageScript('ka', 'Geor');
  static const LanguageScript armenian = LanguageScript('hy', 'Armn');

  // --- Extended Indic Group ---
  static const LanguageScript sanskrit = LanguageScript('sa', 'Deva');
  static const LanguageScript marathi = LanguageScript('mr', 'Deva');
  static const LanguageScript nepali = LanguageScript('ne', 'Deva');
  static const LanguageScript assamese = LanguageScript('as', 'Beng');

  // --- Extended Southeast Asian & Indochina ---
  static const LanguageScript lao = LanguageScript('lo', 'Laoo');
  static const LanguageScript burmese = LanguageScript('my', 'Mymr');
  static const LanguageScript khmer = LanguageScript('km', 'Khmr');

  // --- Extended Middle Eastern & Central Asian ---
  static const LanguageScript kurdish = LanguageScript('ku', 'Arab');
  static const LanguageScript pashto = LanguageScript('ps', 'Arab');
  static const LanguageScript kazakh = LanguageScript('kk', 'Cyrl');

  // --- African (Ge'ez Fidel) & Universal IPA ---
  static const LanguageScript amharic = LanguageScript('am', 'Ethi');
  static const LanguageScript ipa = LanguageScript('und', 'Zyyy');

  /// All 41 officially supported [LanguageScript] constants.
  static const List<LanguageScript> values = [
    bengali,
    latin,
    hindi,
    urdu,
    arabic,
    gujarati,
    tamil,
    telugu,
    punjabi,
    malayalam,
    kannada,
    odia,
    sinhala,
    sanskrit,
    marathi,
    nepali,
    assamese,
    vietnamese,
    thai,
    lao,
    burmese,
    khmer,
    japanese,
    korean,
    chinesePinyin,
    persian,
    hebrew,
    kurdish,
    pashto,
    kazakh,
    russian,
    ukrainian,
    serbian,
    bulgarian,
    macedonian,
    belarusian,
    greek,
    georgian,
    armenian,
    amharic,
    ipa,
  ];

  /// Standard tag code (e.g. 'bn-Beng', 'en-Latn').
  String get code => '$language-$script';

  /// Human-readable display name.
  String get name {
    switch (code) {
      case 'bn-Beng':
        return 'Bengali';
      case 'en-Latn':
        return 'Latin (English)';
      case 'hi-Deva':
        return 'Hindi (Devanagari)';
      case 'ur-Arab':
        return 'Urdu';
      case 'ar-Arab':
        return 'Arabic';
      case 'gu-Gujr':
        return 'Gujarati';
      case 'ta-Taml':
        return 'Tamil';
      case 'te-Telu':
        return 'Telugu';
      case 'pa-Guru':
        return 'Punjabi (Gurmukhi)';
      case 'ml-Mlym':
        return 'Malayalam';
      case 'kn-Knda':
        return 'Kannada';
      case 'or-Orya':
        return 'Odia';
      case 'si-Sinh':
        return 'Sinhala';
      case 'vi-Latn':
        return 'Vietnamese';
      case 'th-Thai':
        return 'Thai';
      case 'ja-Jpan':
        return 'Japanese';
      case 'ko-Hang':
        return 'Korean';
      case 'zh-Latn':
        return 'Chinese (Pinyin)';
      case 'fa-Arab':
        return 'Persian (Farsi)';
      case 'he-Hebr':
        return 'Hebrew';
      case 'ru-Cyrl':
        return 'Russian (Cyrillic)';
      case 'uk-Cyrl':
        return 'Ukrainian';
      case 'el-Grek':
        return 'Greek';
      case 'ka-Geor':
        return 'Georgian';
      case 'hy-Armn':
        return 'Armenian';
      case 'sa-Deva':
        return 'Sanskrit (IAST / Devanagari)';
      case 'mr-Deva':
        return 'Marathi';
      case 'ne-Deva':
        return 'Nepali';
      case 'as-Beng':
        return 'Assamese';
      case 'sr-Cyrl':
        return 'Serbian (Cyrillic)';
      case 'bg-Cyrl':
        return 'Bulgarian';
      case 'mk-Cyrl':
        return 'Macedonian';
      case 'be-Cyrl':
        return 'Belarusian';
      case 'lo-Laoo':
        return 'Lao';
      case 'my-Mymr':
        return 'Burmese (Myanmar)';
      case 'km-Khmr':
        return 'Khmer (Cambodian)';
      case 'ku-Arab':
        return 'Kurdish (Sorani)';
      case 'ps-Arab':
        return 'Pashto';
      case 'kk-Cyrl':
        return 'Kazakh';
      case 'am-Ethi':
        return 'Amharic (Ge\'ez)';
      case 'und-Zyyy':
        return 'International Phonetic Alphabet (IPA)';
      default:
        return '$language ($script)';
    }
  }

  /// Linguistic script family category.
  String get category {
    switch (script) {
      case 'Beng':
      case 'Deva':
      case 'Gujr':
      case 'Taml':
      case 'Telu':
      case 'Guru':
      case 'Mlym':
      case 'Knda':
      case 'Orya':
      case 'Sinh':
        return 'South Asian (Indic)';
      case 'Thai':
      case 'Laoo':
      case 'Mymr':
      case 'Khmr':
        return 'Southeast Asian';
      case 'Latn':
        return language == 'vi' ? 'Southeast Asian' : 'Latin';
      case 'Arab':
      case 'Hebr':
        return 'Middle Eastern';
      case 'Jpan':
      case 'Hang':
        return 'East Asian';
      case 'Cyrl':
      case 'Grek':
        return 'European';
      case 'Geor':
      case 'Armn':
        return 'World Scripts';
      case 'Ethi':
        return 'African (Ge\'ez)';
      case 'Zyyy':
        return 'Phonetic (IPA)';
      default:
        return 'Other';
    }
  }

  /// Parses a code string (e.g. 'bn-Beng', 'bn', or 'Beng') into a [LanguageScript].
  static LanguageScript fromCode(String code) {
    final clean = code.trim().toLowerCase();
    for (final item in values) {
      if (item.code.toLowerCase() == clean ||
          item.language.toLowerCase() == clean ||
          item.script.toLowerCase() == clean) {
        return item;
      }
    }
    final parts = code.split(RegExp(r'[-_]'));
    if (parts.length >= 2) {
      return LanguageScript(parts[0], parts[1]);
    }
    return LanguageScript(code, 'Latn');
  }

  /// Language code in lowercase.
  String get normalizedLanguage => language.trim().toLowerCase();

  /// Script code in titlecase (e.g., 'Latn', 'Beng', 'Deva', 'Arab', etc.).
  String get normalizedScript {
    final trimmed = script.trim();
    if (trimmed.isEmpty) return '';
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageScript &&
          runtimeType == other.runtimeType &&
          normalizedLanguage == other.normalizedLanguage &&
          normalizedScript == other.normalizedScript;

  @override
  int get hashCode => Object.hash(normalizedLanguage, normalizedScript);

  @override
  String toString() => '$language-$script';
}
