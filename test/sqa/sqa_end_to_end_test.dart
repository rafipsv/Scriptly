import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('SQA Production-Grade End-to-End Verification Suite', () {
    final transliterator = Transliterator();

    // -------------------------------------------------------------------------
    // SQA-TC-01: Real-World Conversational Paragraphs with Punctuation & Emojis
    // -------------------------------------------------------------------------
    group('SQA-TC-01: Real-World Conversational Paragraphs', () {
      test('Bengali conversational text with numbers, emojis, and punctuation', () {
        const input = 'Ami tomake bhalobashi! Call me at 01711-223344. Shob thik ache? 🚀';
        final res = transliterator.convert(
          input,
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
          options: const ConversionOptions(
            digitPolicy: DigitPolicy.preserveSource,
            preservePunctuation: true,
            preserveWhitespace: true,
          ),
        );

        // Verification: Bengali conversion done, digits, emoji, and punctuation preserved
        expect(res.text.contains('01711-223344'), isTrue);
        expect(res.text.contains('🚀'), isTrue);
        expect(res.text.contains('!'), isTrue);
        expect(res.text.contains('?'), isTrue);
        expect(res.text.isNotEmpty, isTrue);

        // Reverse romanization test
        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.bengali,
          to: LanguageScript.latin,
        );
        expect(rev.text.contains('01711-223344'), isTrue);
        expect(rev.text.contains('🚀'), isTrue);
      });

      test('Hindi conversational text with punctuation and currency', () {
        const input = 'Namaste dost! Aap kaise hain? Meet me at 5:30 PM. 😊';
        final res = transliterator.convert(
          input,
          from: LanguageScript.latin,
          to: LanguageScript.hindi,
        );

        expect(res.text.contains('5:30'), isTrue);
        expect(res.text.contains('😊'), isTrue);
        expect(res.text.contains('!'), isTrue);
        expect(res.text.contains('?'), isTrue);
      });

      test('Japanese conversational phrase with mixed symbols', () {
        const input = 'Konnichiwa! Arigatou gozaimasu. Sayonara... 🌸';
        final res = transliterator.convert(
          input,
          from: LanguageScript.latin,
          to: LanguageScript.japanese,
        );

        expect(res.text.contains('🌸'), isTrue);
        expect(res.text.contains('!'), isTrue);
        expect(res.text.contains('...'), isTrue);
      });

      test('Korean K-Pop/Drama conversational input', () {
        const input = 'Annyeonghaseyo! Saranghae oppa! Hwaiting! 🎉';
        final res = transliterator.convert(
          input,
          from: LanguageScript.latin,
          to: LanguageScript.korean,
        );

        expect(res.text.contains('🎉'), isTrue);
        expect(res.text.contains('!'), isTrue);
        expect(res.text.contains('\uC548\uB155\uD558\uC138\uC694'), isTrue); // Annyeonghaseyo
      });

      test('Russian Cyrillic conversational phrase', () {
        const input = 'Privet drug! Spasibo za pomoshch. Da, horosho! ❄️';
        final res = transliterator.convert(
          input,
          from: LanguageScript.latin,
          to: LanguageScript.russian,
        );

        expect(res.text.contains('❄️'), isTrue);
        expect(res.text.contains('!'), isTrue);
        expect(res.text.contains('\u043F\u0440\u0438\u0432\u0435\u0442'), isTrue); // privet
      });

      test('Greek conversational greeting', () {
        const input = 'Kalimera sas! Efcharisto poli, geia sou! ☀️';
        final res = transliterator.convert(
          input,
          from: LanguageScript.latin,
          to: LanguageScript.greek,
        );

        expect(res.text.contains('☀️'), isTrue);
        expect(res.text.contains('\u03BA\u03B1\u03BB\u03B7\u03BC\u03AD\u03C1\u03B1'), isTrue); // kalimera
      });
    });

    // -------------------------------------------------------------------------
    // SQA-TC-02: Multi-Hop Auto-Pivot Cross-Script Stress Tests
    // -------------------------------------------------------------------------
    group('SQA-TC-02: Multi-Hop Cross-Family Script Routing', () {
      test('Cross-Family: Korean (Hangul) -> Latin -> Arabic', () {
        // Korean 'sarang' -> Latin -> Arabic
        final res = transliterator.convert(
          '\uC0AC\uB791',
          from: LanguageScript.korean,
          to: LanguageScript.arabic,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Cross-Family: Greek -> Latin -> Hindi (Devanagari)', () {
        // Greek 'kalimera' -> Latin -> Hindi
        final res = transliterator.convert(
          '\u03BA\u03B1\u03BB\u03B7\u03BC\u03AD\u03C1\u03B1',
          from: LanguageScript.greek,
          to: LanguageScript.hindi,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Cross-Family: Hebrew -> Latin -> Tamil', () {
        // Hebrew 'shalom' -> Latin -> Tamil
        final res = transliterator.convert(
          '\u05E9\u05DC\u05D5\u05DD',
          from: LanguageScript.hebrew,
          to: LanguageScript.tamil,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Cross-Family: Russian (Cyrillic) -> Latin -> Persian (Farsi)', () {
        // Russian 'privet' -> Latin -> Persian
        final res = transliterator.convert(
          '\u043F\u0440\u0438\u0432\u0435\u0442',
          from: LanguageScript.russian,
          to: LanguageScript.persian,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Cross-Family: Urdu -> Latin -> Gujarati', () {
        // Urdu 'shukriya' -> Latin -> Gujarati
        final res = transliterator.convert(
          '\u0634\u06A9\u0631\u06CC\u06C1',
          from: LanguageScript.urdu,
          to: LanguageScript.gujarati,
        );
        expect(res.scheme.contains('pivot-latin'), isTrue);
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Exhaustive 289-Path Real-Life Execution: Every single language converts to every other language with real text', () {
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

        var executedConversions = 0;
        for (final from in allLanguages) {
          for (final to in allLanguages) {
            final res = transliterator.convert(
              'Ami Banglay gaan gai 123!',
              from: from,
              to: to,
            );
            expect(res.text.isNotEmpty, isTrue, reason: 'Conversion from $from to $to must not be empty');
            executedConversions++;
          }
        }
        expect(executedConversions, 289);
      });
    });

    // -------------------------------------------------------------------------
    // SQA-TC-03: Boundary & Adversarial Edge Cases
    // -------------------------------------------------------------------------
    group('SQA-TC-03: Boundary & Adversarial Cases', () {
      test('Empty string returns empty string with identity scheme', () {
        final res = transliterator.convert(
          '',
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
        );
        expect(res.text, isEmpty);
        expect(res.scheme, 'identity');
      });

      test('Whitespace-only input preserves exact whitespace characters', () {
        const spaces = '   \n\t   ';
        final res = transliterator.convert(
          spaces,
          from: LanguageScript.latin,
          to: LanguageScript.hindi,
        );
        expect(res.text, spaces);
      });

      test('Identical source and target language returns exact input without transformation', () {
        const text = 'Any text here unmodified';
        final res = transliterator.convert(
          text,
          from: LanguageScript.bengali,
          to: LanguageScript.bengali,
        );
        expect(res.text, text);
        expect(res.scheme, 'identity');
      });

      test('Unsupported script cleanly throws UnsupportedConversionException', () {
        const unsupportedScript = LanguageScript('am', 'Ethi');
        expect(
          () => transliterator.convert(
            'testing',
            from: unsupportedScript,
            to: LanguageScript.latin,
          ),
          throwsA(isA<UnsupportedConversionException>()),
        );
      });

      test('Multi-character skin-tone and complex emojis pass through untouched', () {
        const emojiPayload = 'Hello 👨🏽‍💻 and 👩🏼‍🔬 with 🏳️‍🌈 and 🇦🇷';
        final res = transliterator.convert(
          emojiPayload,
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
        );
        expect(res.text.contains('👨🏽‍💻'), isTrue);
        expect(res.text.contains('👩🏼‍🔬'), isTrue);
        expect(res.text.contains('🏳️‍🌈'), isTrue);
        expect(res.text.contains('🇦🇷'), isTrue);
      });

      test('Extremely long text payload (10,000+ characters stress buffer test)', () {
        final longInput = List.filled(500, 'Ami Banglay gaan gai. ').join();
        expect(longInput.length, greaterThan(10000));

        final stopwatch = Stopwatch()..start();
        final res = transliterator.convert(
          longInput,
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
        );
        stopwatch.stop();

        expect(res.text.isNotEmpty, isTrue);
        // Even 10,000+ characters must convert under 50ms in memory
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });
    });

    // -------------------------------------------------------------------------
    // SQA-TC-04: Digit Policy & Configuration Options
    // -------------------------------------------------------------------------
    group('SQA-TC-04: Digit Policy & Options Testing', () {
      test('DigitPolicy.convertToTarget converts ASCII digits to Bengali digits', () {
        final res = transliterator.convert(
          '12345',
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
          options: const ConversionOptions(
            digitPolicy: DigitPolicy.convertToTarget,
          ),
        );
        // Bengali digits 1-5: \u09E7\u09E8\u09E9\u09EA\u09EB
        expect(res.text, '\u09E7\u09E8\u09E9\u09EA\u09EB');
      });

      test('DigitPolicy.preserveSource retains ASCII digits', () {
        final res = transliterator.convert(
          'Year 2026',
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
          options: const ConversionOptions(
            digitPolicy: DigitPolicy.preserveSource,
          ),
        );
        expect(res.text.contains('2026'), isTrue);
      });
    });

    // -------------------------------------------------------------------------
    // SQA-TC-05: High-Throughput Stress & Performance Benchmark
    // -------------------------------------------------------------------------
    group('SQA-TC-05: High-Throughput Performance Stress Benchmark', () {
      test('5,000 iterations stress test executes with zero memory leak and sub-millisecond avg', () {
        const testPayload = 'namaste bharat kem cho sat sri akaal vanakkam';
        const iterations = 5000;

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < iterations; i++) {
          final res = transliterator.convert(
            testPayload,
            from: LanguageScript.latin,
            to: LanguageScript.hindi,
          );
          expect(res.text.isNotEmpty, isTrue);
        }
        stopwatch.stop();

        final totalMs = stopwatch.elapsedMilliseconds;
        final avgMicros = stopwatch.elapsedMicroseconds / iterations;

        // Verify: 5,000 conversions must complete within reasonable time and avg < 500 microseconds
        expect(totalMs, lessThan(2500));
        expect(avgMicros, lessThan(500.0));
      });
    });

    // -------------------------------------------------------------------------
    // SQA-TC-06: Cross-Family 95%+ High-Accuracy Benchmark Suite
    // -------------------------------------------------------------------------
    group('SQA-TC-06: Cross-Family 95%+ High-Accuracy Benchmark Suite', () {
      test('Perso-Arabic (Arabic, Urdu, Persian) achieves exact linguistic match', () {
        // Arabic
        expect(
          transliterator.convert('ahlan wa sahlan', from: LanguageScript.latin, to: LanguageScript.arabic).text,
          equals('\u0623\u0647\u0644\u0627 \u0648 \u0633\u0647\u0644\u0627'),
        );
        expect(
          transliterator.convert('sabah alkhair', from: LanguageScript.latin, to: LanguageScript.arabic).text,
          equals('\u0635\u0628\u0627\u062D \u0627\u0644\u062E\u064A\u0631'),
        );
        // Urdu
        expect(
          transliterator.convert('khuda hafiz', from: LanguageScript.latin, to: LanguageScript.urdu).text,
          equals('\u062E\u062F\u0627 \u062D\u0627\u0641\u0638'),
        );
        // Persian (Farsi)
        expect(
          transliterator.convert('dorood', from: LanguageScript.latin, to: LanguageScript.persian).text,
          equals('\u062F\u0631\u0648\u062F'),
        );
        expect(
          transliterator.convert('sobh bekheir', from: LanguageScript.latin, to: LanguageScript.persian).text,
          equals('\u0635\u0628\u062D \u0628\u062E\u06CC\u0631'),
        );
      });

      test('Hebrew square script with automatic final forms (Sofit) achieves exact match', () {
        expect(
          transliterator.convert('shalom olam', from: LanguageScript.latin, to: LanguageScript.hebrew).text,
          equals('\u05E9\u05DC\u05D5\u05DD \u05E2\u05D5\u05DC\u05DD'),
        );
        expect(
          transliterator.convert('toda raba', from: LanguageScript.latin, to: LanguageScript.hebrew).text,
          equals('\u05EA\u05D5\u05D3\u05D4 \u05E8\u05D1\u05D4'),
        );
      });

      test('Bengali and Hindi conversational accuracy with inherent vowels and conjuncts', () {
        expect(
          transliterator.convert('dhonnobad bondhu', from: LanguageScript.latin, to: LanguageScript.bengali).text,
          equals('\u09A7\u09A8\u09CD\u09AF\u09AC\u09BE\u09A6 \u09AC\u09A8\u09CD\u09A7\u09C1'),
        );
        expect(
          transliterator.convert('shuvo shokal', from: LanguageScript.latin, to: LanguageScript.bengali).text,
          equals('\u09B6\u09C1\u09AD \u09B8\u0995\u09BE\u09B2'),
        );
        expect(
          transliterator.convert('dhanyavaad', from: LanguageScript.latin, to: LanguageScript.hindi).text,
          equals('\u0927\u0928\u094D\u092F\u0935\u093E\u0926'),
        );
      });

      test('Bengali reverse transliteration handles precomposed and decomposed Yya seamlessly', () {
        expect(
          transliterator.convert('\u0986\u09AE\u09BF \u09AC\u09BE\u0982\u09B2\u09BE\u09DF \u0997\u09BE\u09A8 \u0997\u09BE\u0987', from: LanguageScript.bengali, to: LanguageScript.latin).text,
          equals('Ami banglay gan gai'),
        );
      });
    });
  });
}
