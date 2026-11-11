import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('UnicodeUtils Tests', () {
    test('isBengaliCodePoint identifies Bengali script correctly', () {
      expect(UnicodeUtils.isBengaliCodePoint(0x0985), isTrue); // Shor A
      expect(UnicodeUtils.isBengaliCodePoint(0x0995), isTrue); // Ka
      expect(UnicodeUtils.isBengaliCodePoint(0x0041), isFalse); // ASCII 'A'
    });

    test('containsBengali detects presence of Bengali runes', () {
      expect(UnicodeUtils.containsBengali('\u0986\u09AE\u09BF'), isTrue);
      expect(UnicodeUtils.containsBengali('Ami 123'), isFalse);
    });

    test('digit conversions', () {
      final bengaliDigits = UnicodeUtils.convertAsciiDigitsToBengali(
        'Year 2026',
      );
      expect(bengaliDigits, 'Year \u09E8\u09E6\u09E8\u09EC');

      final asciiDigits = UnicodeUtils.convertBengaliDigitsToAscii(
        '\u09E8\u09E6\u09E8\u09EC',
      );
      expect(asciiDigits, '2026');
    });

    test('grapheme cluster handling with emoji and combining marks', () {
      const text = '\u0995\u09CD\u09B7\u09BF'; // ksh-i
      final graphemes = UnicodeUtils.getGraphemes(text).toList();
      expect(graphemes, isNotEmpty);
    });
  });
}
