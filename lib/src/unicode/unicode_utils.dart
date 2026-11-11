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
  static String convertAsciiDigitsToBengali(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= asciiDigitZero && rune <= asciiDigitZero + 9) {
        final bengaliRune = bengaliDigitZero + (rune - asciiDigitZero);
        buffer.writeCharCode(bengaliRune);
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
}
