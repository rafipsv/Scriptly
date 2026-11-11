import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot_transliterator/polyglot_transliterator.dart';

void main() {
  group('Massive Real-World Multi-Language & Cross-Script Suite', () {
    final transliterator = Transliterator();

    // -------------------------------------------------------------------------
    // 1. South Asian / Indic Group (Direct Brahmic Bridge & Phonetic Matrix)
    // -------------------------------------------------------------------------
    group('1. South Asian / Indic Group', () {
      test('Gujarati bidirectional conversion', () {
        final res = transliterator.convert(
          'kem cho',
          from: LanguageScript.latin,
          to: LanguageScript.gujarati,
        );
        expect(res.text, '\u0A95\u0AC7\u0AAE \u0A9B\u0ACB');

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.gujarati,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Kem cho');
      });

      test('Punjabi / Gurmukhi bidirectional conversion', () {
        final res = transliterator.convert(
          'sat sri akaal',
          from: LanguageScript.latin,
          to: LanguageScript.punjabi,
        );
        expect(res.text, '\u0A38\u0A24\u0A3F \u0A38\u0A4D\u0A30\u0A40 \u0A05\u0A15\u0A3E\u0A32');

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.punjabi,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Sat sri akaal');
      });

      test('Tamil bidirectional conversion', () {
        final res = transliterator.convert(
          'vanakkam',
          from: LanguageScript.latin,
          to: LanguageScript.tamil,
        );
        expect(res.text, '\u0BB5\u0BA3\u0B95\u0BCD\u0B95\u0BAE\u0BCD');

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.tamil,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Vanakkam');
      });

      test('Telugu bidirectional conversion', () {
        final res = transliterator.convert(
          'namaskaram',
          from: LanguageScript.latin,
          to: LanguageScript.telugu,
        );
        expect(res.text, '\u0C28\u0C2E\u0C38\u0C4D\u0C15\u0C3E\u0C30\u0C02');

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.telugu,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Namaskaram');
      });

      test('Malayalam bidirectional conversion', () {
        final res = transliterator.convert(
          'sukhamano',
          from: LanguageScript.latin,
          to: LanguageScript.malayalam,
        );
        expect(res.text, '\u0D38\u0D41\u0D16\u0D2E\u0D3E\u0D23\u0D4B');

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.malayalam,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Sukhamano');
      });

      test('Direct Brahmic cross-script alignment between Indic scripts', () {
        // Gujarati Ka (\u0A95) -> Bengali Ka (\u0995)
        final gujToBeng = transliterator.convert(
          '\u0A95',
          from: LanguageScript.gujarati,
          to: LanguageScript.bengali,
        );
        expect(gujToBeng.text, '\u0995');

        // Bengali Ka (\u0995) -> Devanagari Ka (\u0915)
        final bengToDeva = transliterator.convert(
          '\u0995',
          from: LanguageScript.bengali,
          to: LanguageScript.hindi,
        );
        expect(bengToDeva.text, '\u0915');

        // Devanagari Ka (\u0915) -> Gurmukhi Ka (\u0A15)
        final devaToGuru = transliterator.convert(
          '\u0915',
          from: LanguageScript.hindi,
          to: LanguageScript.punjabi,
        );
        expect(devaToGuru.text, '\u0A15');

        // Gurmukhi Ka (\u0A15) -> Telugu Ka (\u0C15)
        final guruToTelu = transliterator.convert(
          '\u0A15',
          from: LanguageScript.punjabi,
          to: LanguageScript.telugu,
        );
        expect(guruToTelu.text, '\u0C15');
      });
    });

    // -------------------------------------------------------------------------
    // 2. East Asian Group (Japanese, Korean, Chinese Pinyin)
    // -------------------------------------------------------------------------
    group('2. East Asian Group', () {
      test('Japanese Romaji <-> Kana (Hiragana)', () {
        final res1 = transliterator.convert(
          'arigatou',
          from: LanguageScript.latin,
          to: LanguageScript.japanese,
        );
        expect(res1.text, '\u3042\u308A\u304C\u3068\u3046');

        final res2 = transliterator.convert(
          'konnichiwa',
          from: LanguageScript.latin,
          to: LanguageScript.japanese,
        );
        expect(res2.text, '\u3053\u3093\u306B\u3061\u306F');

        final rev = transliterator.convert(
          res1.text,
          from: LanguageScript.japanese,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Arigatou');
      });

      test('Korean Revised Romanization <-> Hangul Syllables', () {
        final res1 = transliterator.convert(
          'annyeonghaseyo',
          from: LanguageScript.latin,
          to: LanguageScript.korean,
        );
        expect(res1.text, '\uC548\uB155\uD558\uC138\uC694');

        final res2 = transliterator.convert(
          'saranghae',
          from: LanguageScript.latin,
          to: LanguageScript.korean,
        );
        expect(res2.text, '\uC0AC\uB791\uD574');

        final rev = transliterator.convert(
          res1.text,
          from: LanguageScript.korean,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Annyeonghaseyo');
      });

      test('Chinese Pinyin numeric tones to diacritics', () {
        final res1 = transliterator.convert(
          'ni3 hao3',
          from: LanguageScript.latin,
          to: LanguageScript.chinesePinyin,
        );
        expect(res1.text, 'nǐ hǎo');

        final res2 = transliterator.convert(
          'zhong1 guo2',
          from: LanguageScript.latin,
          to: LanguageScript.chinesePinyin,
        );
        expect(res2.text, 'zhōng guó');
      });
    });

    // -------------------------------------------------------------------------
    // 3. Middle Eastern & West Asian Group (Persian/Farsi, Hebrew, Arabic, Urdu)
    // -------------------------------------------------------------------------
    group('3. Middle Eastern Group', () {
      test('Persian (Finglish <-> Farsi)', () {
        final res = transliterator.convert(
          'salam',
          from: LanguageScript.latin,
          to: LanguageScript.persian,
        );
        expect(res.text, '\u0633\u0644\u0627\u0645');

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.persian,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Salam');
      });

      test('Hebrew (Roman <-> Hebrew square script)', () {
        final res1 = transliterator.convert(
          'shalom',
          from: LanguageScript.latin,
          to: LanguageScript.hebrew,
        );
        expect(res1.text, '\u05E9\u05DC\u05D5\u05DD');

        final res2 = transliterator.convert(
          'toda',
          from: LanguageScript.latin,
          to: LanguageScript.hebrew,
        );
        expect(res2.text, '\u05EA\u05D5\u05D3\u05D4');

        final rev = transliterator.convert(
          res1.text,
          from: LanguageScript.hebrew,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Shalom');
      });
    });

    // -------------------------------------------------------------------------
    // 4. European / Slavic Group (Russian Cyrillic, Greek)
    // -------------------------------------------------------------------------
    group('4. European / Slavic Group', () {
      test('Russian Cyrillic (ISO 9 standard)', () {
        final res1 = transliterator.convert(
          'privet',
          from: LanguageScript.latin,
          to: LanguageScript.russian,
        );
        expect(res1.text, '\u043F\u0440\u0438\u0432\u0435\u0442');

        final res2 = transliterator.convert(
          'spasibo',
          from: LanguageScript.latin,
          to: LanguageScript.russian,
        );
        expect(res2.text, '\u0441\u043F\u0430\u0441\u0438\u0431\u043E');

        final rev = transliterator.convert(
          res1.text,
          from: LanguageScript.russian,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Privet');
      });

      test('Greek (Greeklish <-> Greek alphabet ISO 843)', () {
        final res1 = transliterator.convert(
          'kalimera',
          from: LanguageScript.latin,
          to: LanguageScript.greek,
        );
        expect(res1.text, '\u03BA\u03B1\u03BB\u03B7\u03BC\u03AD\u03C1\u03B1');

        final res2 = transliterator.convert(
          'efcharisto',
          from: LanguageScript.latin,
          to: LanguageScript.greek,
        );
        expect(res2.text, '\u03B5\u03C5\u03C7\u03B1\u03C1\u03B9\u03C3\u03C4\u03CE');

        final rev = transliterator.convert(
          res1.text,
          from: LanguageScript.greek,
          to: LanguageScript.latin,
        );
        expect(rev.text, 'Kalimera');
      });
    });

    // -------------------------------------------------------------------------
    // 5. Universal Auto-Pivot Routing (Any-to-Any Cross Matrix)
    // -------------------------------------------------------------------------
    group('5. Auto-Pivot Cross-Script Scenarios', () {
      test('Japanese -> Latin -> Bengali', () {
        // Japanese 'arigatou' -> Romaji -> Bengali
        final res = transliterator.convert(
          '\u3042\u308A\u304C\u3068\u3046',
          from: LanguageScript.japanese,
          to: LanguageScript.bengali,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Russian -> Latin -> Urdu', () {
        // Russian 'privet' -> Latin -> Urdu
        final res = transliterator.convert(
          '\u043F\u0440\u0438\u0432\u0435\u0442',
          from: LanguageScript.russian,
          to: LanguageScript.urdu,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Hebrew -> Latin -> Hindi (Devanagari)', () {
        // Hebrew 'shalom' -> Latin -> Hindi
        final res = transliterator.convert(
          '\u05E9\u05DC\u05D5\u05DD',
          from: LanguageScript.hebrew,
          to: LanguageScript.hindi,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Korean -> Latin -> Persian (Farsi)', () {
        // Korean 'saranghae' -> Latin -> Persian
        final res = transliterator.convert(
          '\uC0AC\uB791\uD574',
          from: LanguageScript.korean,
          to: LanguageScript.persian,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Greek -> Latin -> Gujarati', () {
        // Greek 'kalimera' -> Latin -> Gujarati
        final res = transliterator.convert(
          '\u03BA\u03B1\u03BB\u03B7\u03BC\u03AD\u03C1\u03B1',
          from: LanguageScript.greek,
          to: LanguageScript.gujarati,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // 6. Connectivity Matrix & Sub-Millisecond Performance Stress Test
    // -------------------------------------------------------------------------
    group('6. Matrix & Performance Verification', () {
      final allLanguages = [
        LanguageScript.latin,
        LanguageScript.bengali,
        LanguageScript.hindi,
        LanguageScript.gujarati,
        LanguageScript.punjabi,
        LanguageScript.tamil,
        LanguageScript.telugu,
        LanguageScript.malayalam,
        LanguageScript.urdu,
        LanguageScript.arabic,
        LanguageScript.persian,
        LanguageScript.hebrew,
        LanguageScript.japanese,
        LanguageScript.korean,
        LanguageScript.chinesePinyin,
        LanguageScript.russian,
        LanguageScript.greek,
      ];

      test('Full connectivity matrix: every language can convert to Latin and back', () {
        for (final lang in allLanguages) {
          expect(
            transliterator.canConvert(LanguageScript.latin, lang),
            isTrue,
            reason: 'Should convert from Latin to ${lang.language}-${lang.script}',
          );
          expect(
            transliterator.canConvert(lang, LanguageScript.latin),
            isTrue,
            reason: 'Should convert from ${lang.language}-${lang.script} to Latin',
          );
        }
      });

      test('Cross-Language Auto-Pivot Matrix: pairwise connectivity for all combinations', () {
        var pairsCount = 0;
        for (final from in allLanguages) {
          for (final to in allLanguages) {
            final possible = transliterator.canConvert(from, to);
            expect(possible, isTrue, reason: 'Pair $from -> $to must be supported');
            pairsCount++;
          }
        }
        // 17 * 17 = 289 supported conversion paths!
        expect(pairsCount, 289);
      });

      test('Stress test: 1,000 real-world conversions execute within sub-millisecond per-op', () {
        final stopwatch = Stopwatch()..start();
        const iterations = 1000;
        for (var i = 0; i < iterations; i++) {
          transliterator.convert(
            'namaste',
            from: LanguageScript.latin,
            to: LanguageScript.hindi,
          );
        }
        stopwatch.stop();
        final avgMicros = stopwatch.elapsedMicroseconds / iterations;
        // Average operation must take less than 1ms (1000 microseconds)
        expect(avgMicros, lessThan(1000.0));
      });
    });
  });
}
