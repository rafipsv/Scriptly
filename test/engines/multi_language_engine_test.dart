import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('Multi-Language & Cross-Script Engine Tests', () {
    final transliterator = Transliterator();

    test('Hindi (Devanagari) transliteration', () {
      final res = transliterator.convert(
        'namaste',
        from: LanguageScript.latin,
        to: LanguageScript.hindi,
      );
      expect(res.text, '\u0928\u092E\u0938\u094D\u0924\u0947');

      final rev = transliterator.convert(
        '\u0928\u092E\u0938\u094D\u0924\u0947',
        from: LanguageScript.hindi,
        to: LanguageScript.latin,
      );
      expect(rev.text, 'Namaste');
    });

    test('Arabic transliteration', () {
      final res = transliterator.convert(
        'marhaban',
        from: LanguageScript.latin,
        to: LanguageScript.arabic,
      );
      expect(res.text, '\u0645\u0631\u062D\u0628\u0627');

      final rev = transliterator.convert(
        '\u0645\u0631\u062D\u0628\u0627',
        from: LanguageScript.arabic,
        to: LanguageScript.latin,
      );
      expect(rev.text, 'Marhaban');
    });

    test('Urdu transliteration', () {
      final res = transliterator.convert(
        'shukriya',
        from: LanguageScript.latin,
        to: LanguageScript.urdu,
      );
      expect(res.text, '\u0634\u06A9\u0631\u06CC\u06C1');

      final rev = transliterator.convert(
        '\u0634\u06A9\u0631\u06CC\u06C1',
        from: LanguageScript.urdu,
        to: LanguageScript.latin,
      );
      expect(rev.text, 'Shukriya');
    });

    test('Direct Arabic <-> Urdu script harmonizer', () {
      // Arabic Kaf to Urdu Keheh
      final res = transliterator.convert(
        '\u0643',
        from: LanguageScript.arabic,
        to: LanguageScript.urdu,
      );
      expect(res.text, '\u06A9');

      final rev = transliterator.convert(
        '\u06A9',
        from: LanguageScript.urdu,
        to: LanguageScript.arabic,
      );
      expect(rev.text, '\u0643');
    });

    test('Indic Bridge direct Devanagari <-> Bengali transliteration', () {
      // Devanagari Ka (\u0915) -> Bengali Ka (\u0995)
      final res = transliterator.convert(
        '\u0915',
        from: LanguageScript.hindi,
        to: LanguageScript.bengali,
      );
      expect(res.text, '\u0995');

      final rev = transliterator.convert(
        '\u0995',
        from: LanguageScript.bengali,
        to: LanguageScript.hindi,
      );
      expect(rev.text, 'क');
    });

    test('Auto-Pivot Routing through Latin (Urdu -> Latin -> Bengali)', () {
      // Urdu "Aap" -> Latin "aap" -> Bengali
      final res = transliterator.convert(
        '\u0622\u067E',
        from: LanguageScript.urdu,
        to: LanguageScript.bengali,
      );
      expect(res.scheme.contains('pivot-latin'), isTrue);
      expect(res.text.isNotEmpty, isTrue);
    });

    test('canConvert returns true for all interconnected pairs', () {
      expect(
        transliterator.canConvert(LanguageScript.arabic, LanguageScript.urdu),
        isTrue,
      );
      expect(
        transliterator.canConvert(LanguageScript.hindi, LanguageScript.bengali),
        isTrue,
      );
      expect(
        transliterator.canConvert(LanguageScript.urdu, LanguageScript.bengali),
        isTrue,
      );
      expect(
        transliterator.canConvert(LanguageScript.hindi, LanguageScript.arabic),
        isTrue,
      );
    });
  });
}
