import 'package:scriptly/scriptly.dart';

/// Predefined constants and language configurations for the Web App.
class AppConstants {
  AppConstants._();

  /// Supported scripts and readable display names (all 41 scripts).
  static const List<Map<String, dynamic>> supportedLanguages = [
    // --- Global Anchor ---
    {
      'script': LanguageScript.latin,
      'name': 'Latin (English / Roman)',
      'code': 'Latn',
      'category': 'Global',
    },

    // --- Indic Languages & Scripts (14) ---
    {
      'script': LanguageScript.bengali,
      'name': 'Bengali',
      'code': 'Beng',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.hindi,
      'name': 'Hindi (Devanagari)',
      'code': 'Deva',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.sanskrit,
      'name': 'Sanskrit (IAST / Devanagari)',
      'code': 'Skt',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.marathi,
      'name': 'Marathi',
      'code': 'Mra',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.nepali,
      'name': 'Nepali',
      'code': 'Nep',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.assamese,
      'name': 'Assamese',
      'code': 'Asm',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.gujarati,
      'name': 'Gujarati',
      'code': 'Gujr',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.punjabi,
      'name': 'Punjabi (Gurmukhi)',
      'code': 'Guru',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.tamil,
      'name': 'Tamil',
      'code': 'Taml',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.telugu,
      'name': 'Telugu',
      'code': 'Telu',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.malayalam,
      'name': 'Malayalam',
      'code': 'Mlym',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.kannada,
      'name': 'Kannada',
      'code': 'Knda',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.odia,
      'name': 'Odia / Oriya',
      'code': 'Orya',
      'category': 'Indic',
    },
    {
      'script': LanguageScript.sinhala,
      'name': 'Sinhala',
      'code': 'Sinh',
      'category': 'Indic',
    },

    // --- Southeast Asian & Indochina (5) ---
    {
      'script': LanguageScript.vietnamese,
      'name': 'Vietnamese (Telex)',
      'code': 'Viet',
      'category': 'Southeast Asian',
    },
    {
      'script': LanguageScript.thai,
      'name': 'Thai',
      'code': 'Thai',
      'category': 'Southeast Asian',
    },
    {
      'script': LanguageScript.lao,
      'name': 'Lao (UNGEGN)',
      'code': 'Lao',
      'category': 'Southeast Asian',
    },
    {
      'script': LanguageScript.burmese,
      'name': 'Burmese (Myanmar)',
      'code': 'Mymr',
      'category': 'Southeast Asian',
    },
    {
      'script': LanguageScript.khmer,
      'name': 'Khmer (Cambodian)',
      'code': 'Khmr',
      'category': 'Southeast Asian',
    },

    // --- East Asian (3) ---
    {
      'script': LanguageScript.japanese,
      'name': 'Japanese (Kana)',
      'code': 'Jpan',
      'category': 'East Asian',
    },
    {
      'script': LanguageScript.korean,
      'name': 'Korean (Hangul)',
      'code': 'Hang',
      'category': 'East Asian',
    },
    {
      'script': LanguageScript.chinesePinyin,
      'name': 'Chinese Pinyin',
      'code': 'Piny',
      'category': 'East Asian',
    },

    // --- European & Slavic (7) ---
    {
      'script': LanguageScript.russian,
      'name': 'Russian (Cyrillic)',
      'code': 'Cyrl',
      'category': 'European & Slavic',
    },
    {
      'script': LanguageScript.ukrainian,
      'name': 'Ukrainian',
      'code': 'Ukr',
      'category': 'European & Slavic',
    },
    {
      'script': LanguageScript.serbian,
      'name': 'Serbian (Vuk / Gaj)',
      'code': 'Srp',
      'category': 'European & Slavic',
    },
    {
      'script': LanguageScript.bulgarian,
      'name': 'Bulgarian',
      'code': 'Bul',
      'category': 'European & Slavic',
    },
    {
      'script': LanguageScript.macedonian,
      'name': 'Macedonian',
      'code': 'Mkd',
      'category': 'European & Slavic',
    },
    {
      'script': LanguageScript.belarusian,
      'name': 'Belarusian (Lacinka)',
      'code': 'Bel',
      'category': 'European & Slavic',
    },
    {
      'script': LanguageScript.greek,
      'name': 'Greek',
      'code': 'Grek',
      'category': 'European & Slavic',
    },

    // --- Middle Eastern & Central Asian (7) ---
    {
      'script': LanguageScript.arabic,
      'name': 'Arabic',
      'code': 'Arab',
      'category': 'Middle Eastern',
    },
    {
      'script': LanguageScript.urdu,
      'name': 'Urdu (Perso-Arabic)',
      'code': 'Urdu',
      'category': 'Middle Eastern',
    },
    {
      'script': LanguageScript.persian,
      'name': 'Persian (Farsi)',
      'code': 'Fars',
      'category': 'Middle Eastern',
    },
    {
      'script': LanguageScript.hebrew,
      'name': 'Hebrew',
      'code': 'Hebr',
      'category': 'Middle Eastern',
    },
    {
      'script': LanguageScript.kurdish,
      'name': 'Kurdish (Hawar / Sorani)',
      'code': 'Kurd',
      'category': 'Middle Eastern',
    },
    {
      'script': LanguageScript.pashto,
      'name': 'Pashto',
      'code': 'Pst',
      'category': 'Middle Eastern',
    },
    {
      'script': LanguageScript.kazakh,
      'name': 'Kazakh (2021 Latin / Cyrillic)',
      'code': 'Kaz',
      'category': 'Central Asian',
    },

    // --- Caucasus, African & Linguistics (4) ---
    {
      'script': LanguageScript.georgian,
      'name': 'Georgian (Mkhedruli)',
      'code': 'Geor',
      'category': 'Caucasus & World',
    },
    {
      'script': LanguageScript.armenian,
      'name': 'Armenian',
      'code': 'Armn',
      'category': 'Caucasus & World',
    },
    {
      'script': LanguageScript.amharic,
      'name': 'Amharic (Ge\'ez Fidel)',
      'code': 'Amh',
      'category': 'African',
    },
    {
      'script': LanguageScript.ipa,
      'name': 'Universal IPA (Phonetic)',
      'code': 'IPA',
      'category': 'Linguistics',
    },
  ];

  /// Curated quick-testing sample phrases.
  static const List<String> samplePhrases = [
    'Ami Banglay gaan gai',
    'Namaste Bharat',
    'om shanti',
    'maharashtra',
    'nepal',
    'guwahati',
    'Kem cho',
    'Sat sri akaal',
    'Vanakkam',
    'Namaskaram',
    'Namaskara',
    'Kemiti achanti',
    'Ayubowan',
    'Xin chao',
    'Sawatdee',
    'sabaidee',
    'mingalaba',
    'suesdei',
    'Arigatou',
    'Annyeonghaseyo',
    'Ni3 hao3',
    'Privet mir',
    'Pryvit svit',
    'beograd',
    'sofia',
    'skopje',
    'minsk',
    'Kalimera',
    'Marhaban',
    'Shukriya',
    'Chetori',
    'Shalom',
    'slaw',
    'manana',
    'salem',
    'Gamarjoba',
    'Barev',
    'selam',
    'shanti',
  ];
}
