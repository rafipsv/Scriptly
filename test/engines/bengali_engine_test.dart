import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot_transliterator/polyglot_transliterator.dart';

void main() {
  group('Bengali Transliterator Tests', () {
    final bn = BengaliTransliterator();

    group('Latin/Banglish -> Bengali Acceptance Tests (Spec Section 8)', () {
      test('converts simple words and proper nouns correctly', () {
        expect(bn.toBengali('Dhaka'), '\u09A2\u09BE\u0995\u09BE');
        expect(bn.toBengali('Ami'), '\u0986\u09AE\u09BF');
        expect(
          bn.toBengali('Bangladesh'),
          '\u09AC\u09BE\u0982\u09B2\u09BE\u09A6\u09C7\u09B6',
        );
        expect(bn.toBengali('Bhalo'), '\u09AD\u09BE\u09B2\u09CB');
        expect(
          bn.toBengali('Kemon acho'),
          '\u0995\u09C7\u09AE\u09A8 \u0986\u099B\u09CB',
        );
      });

      test('converts complete sentences', () {
        expect(
          bn.toBengali('Ami Banglay likhi'),
          '\u0986\u09AE\u09BF \u09AC\u09BE\u0982\u09B2\u09BE\u09DF \u09B2\u09BF\u0996\u09BF',
        );
        expect(
          bn.toBengali('Ami Banglay gaan gai'),
          '\u0986\u09AE\u09BF \u09AC\u09BE\u0982\u09B2\u09BE\u09DF \u0997\u09BE\u09A8 \u0997\u09BE\u0987',
        );
        expect(
          bn.toBengali('Ami Bangladeshe thaki'),
          '\u0986\u09AE\u09BF \u09AC\u09BE\u0982\u09B2\u09BE\u09A6\u09C7\u09B6\u09C7 \u09A5\u09BE\u0995\u09BF',
        );
      });

      test('preserves whitespace, punctuation, and emoji', () {
        const input = 'Ami Banglay likhi! 😊 How are you?';
        final output = bn.toBengali(input);
        expect(output.contains('😊'), isTrue);
        expect(output.contains('!'), isTrue);
        expect(
          output.contains(
            '\u0986\u09AE\u09BF \u09AC\u09BE\u0982\u09B2\u09BE\u09DF \u09B2\u09BF\u0996\u09BF!',
          ),
          isTrue,
        );
      });

      test('respects digit policy', () {
        const withDigits = 'Dhaka 2026';
        final convertedDigits = bn.toBengali(
          withDigits,
          options: const ConversionOptions(
            digitPolicy: DigitPolicy.convertToTarget,
          ),
        );
        expect(
          convertedDigits,
          '\u09A2\u09BE\u0995\u09BE \u09E8\u09E6\u09E8\u09EC',
        );

        final preservedDigits = bn.toBengali(
          withDigits,
          options: const ConversionOptions(
            digitPolicy: DigitPolicy.preserveSource,
          ),
        );
        expect(preservedDigits, '\u09A2\u09BE\u0995\u09BE 2026');
      });

      test(
        'handles empty string and repeated identical inputs deterministically',
        () {
          expect(bn.toBengali(''), '');
          final res1 = bn.toBengali('Bangladesh');
          final res2 = bn.toBengali('Bangladesh');
          expect(res1, res2);
        },
      );
    });

    group('Bengali -> Latin Romanization Tests', () {
      test('romanizes common words and sentences', () {
        expect(bn.toLatin('\u09A2\u09BE\u0995\u09BE'), 'Dhaka');
        expect(bn.toLatin('\u0986\u09AE\u09BF'), 'Ami');
        expect(
          bn.toLatin('\u09AC\u09BE\u0982\u09B2\u09BE\u09A6\u09C7\u09B6'),
          'Bangladesh',
        );
        expect(bn.toLatin('\u09AD\u09BE\u09B2\u09CB'), 'Bhalo');
        expect(
          bn.toLatin('\u0995\u09C7\u09AE\u09A8 \u0986\u099B\u09CB'),
          'Kemon acho',
        );
      });

      test('preserves punctuation and whitespace during romanization', () {
        final res = bn.toLatin(
          '\u0986\u09AE\u09BF \u09AC\u09BE\u0982\u09B2\u09BE\u09DF \u09B2\u09BF\u0996\u09BF! 👍',
        );
        expect(res.contains('!'), isTrue);
        expect(res.contains('👍'), isTrue);
      });
    });
  });
}
