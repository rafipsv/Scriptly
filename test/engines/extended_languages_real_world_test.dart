import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('Extended Languages & Real-World Precision Test Suite', () {
    late Transliterator transliterator;

    setUp(() {
      transliterator = Transliterator();
    });

    // =========================================================================
    // 1. South Asian (Indic) Extended Suite
    // =========================================================================
    group('Tier 1: Indic Extended Languages (Kannada, Odia, Sinhala)', () {
      test('Kannada conversational transliteration with punctuation', () {
        final result = transliterator.convert(
          'Namaskara! Hegiddeera? Bengaluru 2026 😊',
          from: LanguageScript.latin,
          to: LanguageScript.kannada,
        );

        expect(result.text, contains('\u0CA8\u0CAE\u0CB8\u0CCD\u0C95\u0CBE\u0CB0')); // ನಮಸ್ಕಾರ
        expect(result.text, contains('!'));
        expect(result.text, contains('?'));
        expect(result.text, contains('2026'));
        expect(result.text, contains('😊'));
      });

      test('Odia conversational transliteration with punctuation', () {
        final result = transliterator.convert(
          'Namaskar! Kemiti achanti? Odisha 100%',
          from: LanguageScript.latin,
          to: LanguageScript.odia,
        );

        expect(result.text, contains('\u0B28\u0B2E\u0B38\u0B4D\u0B15\u0B3E\u0B30')); // ନମସ୍କାର
        expect(result.text, contains('!'));
        expect(result.text, contains('?'));
        expect(result.text, contains('100%'));
      });

      test('Sinhala conversational transliteration with punctuation', () {
        final result = transliterator.convert(
          'Ayubowan! Kohomada? Sri Lanka 24/7',
          from: LanguageScript.latin,
          to: LanguageScript.sinhala,
        );

        expect(result.text, contains('\u0D86\u0DBA\u0DD4\u0DB6\u0DDD\u0DC0\u0DB1\u0DCA')); // ආයුබෝවන්
        expect(result.text, contains('!'));
        expect(result.text, contains('?'));
        expect(result.text, contains('24/7'));
      });

      test('Direct Brahmic Cross-Script Bridge between Indic extended pairs', () {
        // Direct Devanagari to Kannada (zero romanization bridge)
        final kn = transliterator.convert(
          'नमस्ते',
          from: LanguageScript.hindi,
          to: LanguageScript.kannada,
        );
        expect(kn.text.isNotEmpty, isTrue);

        // Direct Bengali to Odia (zero romanization bridge)
        final od = transliterator.convert(
          'নমস্কার',
          from: LanguageScript.bengali,
          to: LanguageScript.odia,
        );
        expect(od.text.isNotEmpty, isTrue);
      });
    });

    // =========================================================================
    // 2. Southeast Asian Suite
    // =========================================================================
    group('Tier 2: Southeast Asian Languages (Vietnamese Telex & Thai RTGS)', () {
      test('Vietnamese conversational Telex typing', () {
        final r1 = transliterator.convert(
          'Xin chao! Cam on ban rat nhieu. Viet Nam 🇻🇳',
          from: LanguageScript.latin,
          to: LanguageScript.vietnamese,
        );

        expect(r1.text, contains('Xin chào!'));
        expect(r1.text, contains('Cảm ơn'));
        expect(r1.text, contains('Việt Nam'));
        expect(r1.text, contains('🇻🇳'));
      });

      test('Vietnamese Telex tone keys (s, f, r, x, j)', () {
        // Acute (s), Grave (f), Hook (r), Tilde (x), Dot below (j)
        expect(
          transliterator.convert('chaof', from: LanguageScript.latin, to: LanguageScript.vietnamese).text,
          equals('chào'),
        );
        expect(
          transliterator.convert('carm', from: LanguageScript.latin, to: LanguageScript.vietnamese).text,
          equals('cảm'),
        );
        expect(
          transliterator.convert('tamj', from: LanguageScript.latin, to: LanguageScript.vietnamese).text,
          equals('tạm'),
        );
      });

      test('Vietnamese to Latin reverse accent stripping', () {
        final reversed = transliterator.convert(
          'Xin chào Việt Nam!',
          from: LanguageScript.vietnamese,
          to: LanguageScript.latin,
        );

        expect(reversed.text, equals('Xin chao Viet Nam!'));
      });

      test('Thai conversational RTGS transliteration with symbols', () {
        final thai = transliterator.convert(
          'Sawatdee! Sabai dee? Bangkok 2026 🇹🇭',
          from: LanguageScript.latin,
          to: LanguageScript.thai,
        );

        expect(thai.text, contains('สวัสดี!'));
        expect(thai.text, contains('สบายดี?'));
        expect(thai.text, contains('บางกอก'));
        expect(thai.text, contains('🇹🇭'));
      });

      test('Thai to Latin RTGS reverse transliteration', () {
        final lat = transliterator.convert(
          'สวัสดี',
          from: LanguageScript.thai,
          to: LanguageScript.latin,
        );

        expect(lat.text, equals('Sawatdee'));
      });
    });

    // =========================================================================
    // 3. Unique World Scripts Suite
    // =========================================================================
    group('Tier 3: World Scripts (Georgian, Armenian, Ukrainian)', () {
      test('Georgian Mkhedruli conversational transliteration (National 2002)', () {
        final geo = transliterator.convert(
          'Gamarjoba! Madloba. Sakartvelo 🇬🇪',
          from: LanguageScript.latin,
          to: LanguageScript.georgian,
        );

        expect(geo.text, contains('გამარჯობა!'));
        expect(geo.text, contains('მადლობა.'));
        expect(geo.text, contains('საქართველო'));
        expect(geo.text, contains('🇬🇪'));

        // Reverse
        final rev = transliterator.convert(
          'გამარჯობა',
          from: LanguageScript.georgian,
          to: LanguageScript.latin,
        );
        expect(rev.text, equals('Gamarjoba'));
      });

      test('Armenian ISO 9985 conversational transliteration', () {
        final arm = transliterator.convert(
          'Barev! Shnorhakalutyun. Hayastan 🇦🇲',
          from: LanguageScript.latin,
          to: LanguageScript.armenian,
        );

        expect(arm.text, contains('բարև!'));
        expect(arm.text, contains('շնորհակալություն.'));
        expect(arm.text, contains('հայաստան'));
        expect(arm.text, contains('🇦🇲'));

        // Reverse
        final rev = transliterator.convert(
          'բարև',
          from: LanguageScript.armenian,
          to: LanguageScript.latin,
        );
        expect(rev.text, equals('Barev'));
      });

      test('Ukrainian Cyrillic conversational transliteration (Resolution 55)', () {
        final ukr = transliterator.convert(
          'Pryvit! Dyakuyu. Ukrayina 🇺🇦 100%',
          from: LanguageScript.latin,
          to: LanguageScript.ukrainian,
        );

        expect(ukr.text, contains('привіт!'));
        expect(ukr.text, contains('дякую.'));
        expect(ukr.text, contains('україна'));
        expect(ukr.text, contains('100%'));

        // Reverse
        final rev = transliterator.convert(
          'привіт',
          from: LanguageScript.ukrainian,
          to: LanguageScript.latin,
        );
        expect(rev.text, equals('Pryvit'));
      });
    });

    // =========================================================================
    // 4. Universal Auto-Pivot Multi-Hop Cross-Family Routing
    // =========================================================================
    group('Universal Auto-Pivot Multi-Hop Scenarios', () {
      test('Vietnamese -> Latin -> Kannada', () {
        final res = transliterator.convert(
          'Xin chào',
          from: LanguageScript.vietnamese,
          to: LanguageScript.kannada,
        );
        expect(res.text.isNotEmpty, isTrue);
        expect(res.scheme, contains('pivot-latin'));
      });

      test('Georgian -> Latin -> Thai', () {
        final res = transliterator.convert(
          'გამარჯობა',
          from: LanguageScript.georgian,
          to: LanguageScript.thai,
        );
        expect(res.text.isNotEmpty, isTrue);
        expect(res.scheme, contains('pivot-latin'));
      });

      test('Ukrainian -> Latin -> Odia', () {
        final res = transliterator.convert(
          'дякую',
          from: LanguageScript.ukrainian,
          to: LanguageScript.odia,
        );
        expect(res.text.isNotEmpty, isTrue);
        expect(res.scheme, contains('pivot-latin'));
      });

      test('Armenian -> Latin -> Sinhala', () {
        final res = transliterator.convert(
          'բարև',
          from: LanguageScript.armenian,
          to: LanguageScript.sinhala,
        );
        expect(res.text.isNotEmpty, isTrue);
        expect(res.scheme, contains('pivot-latin'));
      });

      test('Total supported scripts is now 25', () {
        final scripts = [
          LanguageScript.latin,
          LanguageScript.bengali,
          LanguageScript.hindi,
          LanguageScript.gujarati,
          LanguageScript.punjabi,
          LanguageScript.tamil,
          LanguageScript.telugu,
          LanguageScript.malayalam,
          LanguageScript.kannada,
          LanguageScript.odia,
          LanguageScript.sinhala,
          LanguageScript.vietnamese,
          LanguageScript.thai,
          LanguageScript.urdu,
          LanguageScript.arabic,
          LanguageScript.persian,
          LanguageScript.hebrew,
          LanguageScript.japanese,
          LanguageScript.korean,
          LanguageScript.chinesePinyin,
          LanguageScript.russian,
          LanguageScript.ukrainian,
          LanguageScript.greek,
          LanguageScript.georgian,
          LanguageScript.armenian,
        ];

        expect(scripts.length, equals(25));
        for (final s in scripts) {
          expect(transliterator.canConvert(LanguageScript.latin, s), isTrue);
          expect(transliterator.canConvert(s, LanguageScript.latin), isTrue);
        }
      });
    });
  });
}
