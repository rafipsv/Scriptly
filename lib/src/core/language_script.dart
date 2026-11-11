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

  // --- East Asian Group ---
  static const LanguageScript japanese = LanguageScript('ja', 'Jpan');
  static const LanguageScript korean = LanguageScript('ko', 'Hang');
  static const LanguageScript chinesePinyin = LanguageScript('zh', 'Latn');

  // --- Middle Eastern Group ---
  static const LanguageScript persian = LanguageScript('fa', 'Arab');
  static const LanguageScript hebrew = LanguageScript('he', 'Hebr');

  // --- European / Slavic Group ---
  static const LanguageScript russian = LanguageScript('ru', 'Cyrl');
  static const LanguageScript greek = LanguageScript('el', 'Grek');

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
