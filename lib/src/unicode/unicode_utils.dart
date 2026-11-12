import 'package:characters/characters.dart';

/// Utilities for Unicode-safe operations, script inspection, and grapheme handling.
class UnicodeUtils {
  UnicodeUtils._();

  /// Bengali Unicode block start (inclusive).
  static const int bengaliBlockStart = 0x0980;

  /// Bengali Unicode block end (inclusive).
  static const int bengaliBlockEnd = 0x09FF;

  /// Bengali Virama (Hasanta) code unit: U+09CD.
  static const String hasanta = '\u09CD';

  /// Bengali Anusvara: U+0982.
  static const String anusvara = '\u0982';

  /// Bengali Visarga: U+0983.
  static const String visarga = '\u0983';

  /// Bengali Candrabindu: U+0981.
  static const String candrabindu = '\u0981';

  /// Bengali Khanda Ta: U+09CE.
  static const String khandaTa = '\u09CE';

  /// Bengali Nukta: U+09BC.
  static const String nukta = '\u09BC';

  /// Devanagari/Bengali Danda (Dari): U+0964.
  static const String danda = '\u0964';

  /// Bengali digit zero: U+09E6.
  static const int bengaliDigitZero = 0x09E6;

  /// ASCII digit zero: 0x30 ('0').
  static const int asciiDigitZero = 0x30;

  /// Checks if a character / code point belongs to the Bengali Unicode block.
  static bool isBengaliCodePoint(int codePoint) {
    return codePoint >= bengaliBlockStart && codePoint <= bengaliBlockEnd;
  }

  /// Checks if the given string contains any Bengali characters.
  static bool containsBengali(String text) {
    for (final rune in text.runes) {
      if (isBengaliCodePoint(rune)) return true;
    }
    return false;
  }

  /// Checks if the given string is strictly composed of Bengali characters and whitespace/punctuation.
  static bool isAllBengali(String text) {
    for (final rune in text.runes) {
      if (!isBengaliCodePoint(rune) && !isWhitespaceOrPunctuation(rune)) {
        return false;
      }
    }
    return true;
  }

  /// Checks if a rune is whitespace or common punctuation.
  static bool isWhitespaceOrPunctuation(int rune) {
    if (rune == 0x20 || rune == 0x09 || rune == 0x0A || rune == 0x0D) {
      return true;
    }
    // ASCII punctuation
    if ((rune >= 0x21 && rune <= 0x2F) ||
        (rune >= 0x3A && rune <= 0x40) ||
        (rune >= 0x5B && rune <= 0x60) ||
        (rune >= 0x7B && rune <= 0x7E)) {
      return true;
    }
    // Bengali danda & double danda
    if (rune == 0x0964 || rune == 0x0965) {
      return true;
    }
    return false;
  }

  /// Converts ASCII digits (0-9) to Bengali digits (\u09E6-\u09EF).
  static String convertAsciiDigitsToBengali(String input) =>
      convertAsciiDigitsToScript(input, 0x09E6);

  /// Converts ASCII digits to the native numeral script based on target script or zero-offset.
  static String convertAsciiDigitsToScript(
    String input,
    dynamic scriptOrZeroRune,
  ) {
    int? zeroRune;
    if (scriptOrZeroRune is int) {
      zeroRune = scriptOrZeroRune;
    } else {
      final code = scriptOrZeroRune.toString();
      if (code.contains('Beng')) {
        zeroRune = 0x09E6;
      } else if (code.contains('Deva')) {
        zeroRune = 0x0966;
      } else if (code.contains('Guru')) {
        zeroRune = 0x0A66;
      } else if (code.contains('Gujr')) {
        zeroRune = 0x0AE6;
      } else if (code.contains('Orya')) {
        zeroRune = 0x0B66;
      } else if (code.contains('Taml')) {
        zeroRune = 0x0BE6;
      } else if (code.contains('Telu')) {
        zeroRune = 0x0C66;
      } else if (code.contains('Knda')) {
        zeroRune = 0x0CE6;
      } else if (code.contains('Mlym')) {
        zeroRune = 0x0D66;
      } else if (code.contains('Thai')) {
        zeroRune = 0x0E50;
      } else if (code.contains('Laoo')) {
        zeroRune = 0x0ED0;
      } else if (code.contains('Mymr')) {
        zeroRune = 0x1040;
      } else if (code.contains('Khmr')) {
        zeroRune = 0x17E0;
      } else if (code.contains('fa') || code.contains('ur')) {
        zeroRune = 0x06F0;
      } else if (code.contains('ar') || code.contains('Arab')) {
        zeroRune = 0x0660;
      }
    }

    if (zeroRune == null) return input;

    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= asciiDigitZero && rune <= asciiDigitZero + 9) {
        final targetRune = zeroRune + (rune - asciiDigitZero);
        buffer.writeCharCode(targetRune);
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  /// Converts Bengali digits (\u09E6-\u09EF) to ASCII digits (0-9).
  static String convertBengaliDigitsToAscii(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= bengaliDigitZero && rune <= bengaliDigitZero + 9) {
        final asciiRune = asciiDigitZero + (rune - bengaliDigitZero);
        buffer.writeCharCode(asciiRune);
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  /// Returns user-perceived grapheme clusters using `package:characters`.
  static Iterable<String> getGraphemes(String text) {
    return text.characters;
  }

  /// Normalizes Unicode text into canonical precomposed form, reconciling decomposed
  /// Nuktas, combining diacritics, and language-specific decomposed codepoints.
  static String normalizeCanonical(String input) {
    if (input.isEmpty) return input;

    var s = input;

    // 1. Indic Decomposed Nukta Precomposition
    // Bengali: ড+় -> ড়, ঢ+় -> ঢ়, য+় -> য়
    s = s.replaceAll('\u09A1\u09BC', '\u09DD');
    s = s.replaceAll('\u09A2\u09BC', '\u09DE');
    s = s.replaceAll('\u09AF\u09BC', '\u09DF');

    // Devanagari: क़, ख़, ग़, ज़, ड़, ढ़, फ़, य़
    s = s.replaceAll('\u0915\u093C', '\u0958');
    s = s.replaceAll('\u0916\u093C', '\u0959');
    s = s.replaceAll('\u0917\u093C', '\u095A');
    s = s.replaceAll('\u091C\u093C', '\u095B');
    s = s.replaceAll('\u0921\u093C', '\u095C');
    s = s.replaceAll('\u0922\u093C', '\u095D');
    s = s.replaceAll('\u092B\u093C', '\u095E');
    s = s.replaceAll('\u092F\u093C', '\u095F');

    // 2. Cyrillic Combining Breve / Diaeresis
    // и + \u0306 -> й, И + \u0306 -> Й
    s = s.replaceAll('\u0438\u0306', '\u0439');
    s = s.replaceAll('\u0418\u0306', '\u0419');
    // е + \u0308 -> ё, Е + \u0308 -> Ё
    s = s.replaceAll('\u0435\u0308', '\u0451');
    s = s.replaceAll('\u0415\u0308', '\u0401');
    // у + \u0306 -> ў (Belarusian), У + \u0306 -> Ў
    s = s.replaceAll('\u0443\u0306', '\u045E');
    s = s.replaceAll('\u0423\u0306', '\u040E');

    // 3. Arabic / Perso-Arabic Combining Diacritics Canonicalization
    s = s.replaceAll('\u0627\u0653', '\u0622'); // Alif + Madda -> Alif Madda
    s = s.replaceAll(
      '\u0627\u0654',
      '\u0623',
    ); // Alif + Hamza Above -> Alif Hamza Above
    s = s.replaceAll(
      '\u0627\u0655',
      '\u0625',
    ); // Alif + Hamza Below -> Alif Hamza Below

    // 4. Latin Decomposed Vowels with Combining Accents
    s = s
        .replaceAll('a\u0300', 'à')
        .replaceAll('a\u0301', 'á')
        .replaceAll('a\u0303', 'ã');
    s = s
        .replaceAll('e\u0300', 'è')
        .replaceAll('e\u0301', 'é')
        .replaceAll('e\u0302', 'ê');
    s = s.replaceAll('i\u0300', 'ì').replaceAll('i\u0301', 'í');
    s = s
        .replaceAll('o\u0300', 'ò')
        .replaceAll('o\u0301', 'ó')
        .replaceAll('o\u0303', 'õ');
    s = s.replaceAll('u\u0300', 'ù').replaceAll('u\u0301', 'ú');

    return s;
  }

  /// Wraps directional tokens (such as URLs, technical identifiers, or embedded LTR phrases)
  /// with Unicode Directional Isolates (U+2066 LRI / U+2069 PDI) to prevent RTL layout distortion.
  static String wrapBidiIsolates(String text, {required bool isRtlTarget}) {
    if (!isRtlTarget || text.isEmpty) return text;

    final ltrTokenRegex = RegExp(
      r'(https?:\/\/[^\s]+|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}|[a-zA-Z0-9_]{3,})',
    );
    return text.replaceAllMapped(ltrTokenRegex, (m) {
      final token = m.group(0)!;
      return '\u2066$token\u2069';
    });
  }
}
