import 'package:scriptly/scriptly.dart';

/// Predefined constants and language configurations for the Web App.
class AppConstants {
  AppConstants._();

  /// Supported scripts and readable display names.
  static const List<Map<String, dynamic>> supportedLanguages = [
    {
      'script': LanguageScript.latin,
      'name': 'Latin (English / Roman)',
      'code': 'Latn',
      'category': 'Global',
    },
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
      'script': LanguageScript.urdu,
      'name': 'Urdu (Perso-Arabic)',
      'code': 'Urdu',
      'category': 'Middle Eastern',
    },
    {
      'script': LanguageScript.arabic,
      'name': 'Arabic',
      'code': 'Arab',
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
    {
      'script': LanguageScript.russian,
      'name': 'Russian (Cyrillic)',
      'code': 'Cyrl',
      'category': 'European',
    },
    {
      'script': LanguageScript.greek,
      'name': 'Greek',
      'code': 'Grek',
      'category': 'European',
    },
  ];

  /// Curated quick-testing sample phrases.
  static const List<String> samplePhrases = [
    'Ami Banglay gaan gai',
    'Namaste Bharat',
    'Kem cho',
    'Sat sri akaal',
    'Vanakkam',
    'Namaskaram',
    'Shukriya',
    'Marhaban',
    'Chetori',
    'Shalom',
    'Arigatou',
    'Annyeonghaseyo',
    'Ni3 hao3',
    'Privet',
    'Kalimera',
  ];
}
