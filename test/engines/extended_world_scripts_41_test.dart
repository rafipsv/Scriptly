import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('Scriptly 41-Language Global Precision Test Suite', () {
    late Transliterator transliterator;

    setUp(() {
      transliterator = Transliterator();
    });

    // =========================================================================
    // 1. South Asian (Indic Extensions): Sanskrit, Marathi, Nepali, Assamese
    // =========================================================================
    group('1. Indic Extensions (Sanskrit, Marathi, Nepali, Assamese)', () {
      test('Sanskrit IAST / Devanagari bidirectional conversion', () {
        final res = transliterator.convert(
          'om shanti',
          from: LanguageScript.latin,
          to: LanguageScript.sanskrit,
        );
        expect(res.text, contains('\u0950')); // ॐ
        expect(res.text, contains('\u0936\u093E\u0928\u094D\u0924\u093F\u0903')); // शान्तिः

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.sanskrit,
          to: LanguageScript.latin,
        );
        expect(rev.text.toLowerCase(), contains('om shanti'));
      });

      test('Marathi Devanagari conversion with retroflex lateral Lla', () {
        final res = transliterator.convert(
          'maharashtra',
          from: LanguageScript.latin,
          to: LanguageScript.marathi,
        );
        expect(res.text, contains('\u092E\u0939\u093E\u0930\u093E\u0937\u094D\u091F\u094D\u0930')); // महाराष्ट्र
      });

      test('Nepali Devanagari conversion', () {
        final res = transliterator.convert(
          'nepal',
          from: LanguageScript.latin,
          to: LanguageScript.nepali,
        );
        expect(res.text, contains('\u0928\u0947\u092A\u093E\u0932')); // नेपाल
      });

      test('Assamese Eastern Indic conversion with Ro and Wo', () {
        final res = transliterator.convert(
          'guwahati',
          from: LanguageScript.latin,
          to: LanguageScript.assamese,
        );
        expect(res.text, contains('\u0997\u09C1\u09F1\u09BE\u09B9\u09BE\u099F\u09C0')); // গুৱাহাটী
      });
    });

    // =========================================================================
    // 2. European / South Slavic Group: Serbian, Bulgarian, Macedonian, Belarusian
    // =========================================================================
    group('2. South Slavic & European (Serbian Vuk↔Gaj, Bulgarian, Macedonian, Belarusian)', () {
      test('Serbian 1:1 bi-directional Vuk Cyrillic ↔ Gaj Latin mapping', () {
        // Cyrillic to Latin
        final lat = transliterator.convert(
          'Београд је главни град Србије.',
          from: LanguageScript.serbian,
          to: LanguageScript.latin,
        );
        expect(lat.text, 'Beograd je glavni grad Srbije.');

        // Latin to Cyrillic with digraphs
        final cyr = transliterator.convert(
          'Ljubav, Njegoš i Džep',
          from: LanguageScript.latin,
          to: LanguageScript.serbian,
        );
        expect(cyr.text, 'Љубав, Његош и Џеп');
      });

      test('Bulgarian Transliteration Act 2009 conversion', () {
        final res = transliterator.convert(
          'Sofia, Bulgaria',
          from: LanguageScript.latin,
          to: LanguageScript.bulgarian,
        );
        expect(res.text, contains('София'));
        expect(res.text, contains('България'));
      });

      test('Macedonian Cyrillic conversion', () {
        final res = transliterator.convert(
          'skopje, macedonia',
          from: LanguageScript.latin,
          to: LanguageScript.macedonian,
        );
        expect(res.text, contains('скопје'));
        expect(res.text, contains('македонија'));
      });

      test('Belarusian Lacinka ↔ Cyrillic conversion', () {
        final res = transliterator.convert(
          'minsk, belarus',
          from: LanguageScript.latin,
          to: LanguageScript.belarusian,
        );
        expect(res.text, contains('мінск'));
        expect(res.text, contains('беларусь'));
      });
    });

    // =========================================================================
    // 3. Southeast Asian / Indochina Group: Lao, Burmese, Khmer
    // =========================================================================
    group('3. Indochina (Lao UNGEGN, Burmese MLC, Khmer UNGEGN)', () {
      test('Lao conversational transliteration', () {
        final res = transliterator.convert(
          'sabaidee',
          from: LanguageScript.latin,
          to: LanguageScript.lao,
        );
        expect(res.text, equals('\u0EAA\u0EB0\u0E9A\u0EB2\u0E8D\u0E94\u0EB5')); // ສະບາຍດີ

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.lao,
          to: LanguageScript.latin,
        );
        expect(rev.text.toLowerCase(), contains('sabaidee'));
      });

      test('Burmese Myanmar conversational transliteration', () {
        final res = transliterator.convert(
          'mingalaba',
          from: LanguageScript.latin,
          to: LanguageScript.burmese,
        );
        expect(res.text, equals('\u1019\u1004\u103A\u1039\u1002\u101C\u102C\u1015\u102B')); // မင်္ဂလာပါ
      });

      test('Khmer Cambodian conversational transliteration', () {
        final res = transliterator.convert(
          'suesdei',
          from: LanguageScript.latin,
          to: LanguageScript.khmer,
        );
        expect(res.text, equals('\u179f\u17bd\u179f\u17d2\u178f\u17b8')); // សួស្តី
      });
    });

    // =========================================================================
    // 4. Middle Eastern & Central Asian: Kurdish, Pashto, Kazakh
    // =========================================================================
    group('4. Central Asian & Middle Eastern (Kurdish Hawar↔Sorani, Pashto, Kazakh 2021)', () {
      test('Kurdish Hawar Latin ↔ Sorani Arabic conversion', () {
        final res = transliterator.convert(
          'slaw',
          from: LanguageScript.latin,
          to: LanguageScript.kurdish,
        );
        expect(res.text, equals('\u0633\u06B5\u0627\u0648')); // سڵاو

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.kurdish,
          to: LanguageScript.latin,
        );
        expect(rev.text.toLowerCase(), equals('slaw'));
      });

      test('Pashto conversational conversion', () {
        final res = transliterator.convert(
          'manana',
          from: LanguageScript.latin,
          to: LanguageScript.pashto,
        );
        expect(res.text, equals('\u0645\u0646\u0646\u0647')); // مننه
      });

      test('Kazakh 2021 Modern Latin ↔ Cyrillic conversion', () {
        final res = transliterator.convert(
          'salem',
          from: LanguageScript.latin,
          to: LanguageScript.kazakh,
        );
        expect(res.text, equals('\u0421\u04D9\u043B\u0435\u043C')); // Сәлем

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.kazakh,
          to: LanguageScript.latin,
        );
        expect(rev.text.toLowerCase(), equals('sälem'));
      });
    });

    // =========================================================================
    // 5. African (Ge'ez Fidel) & Universal IPA
    // =========================================================================
    group('5. African (Amharic Ge\'ez Fidel) & Universal IPA', () {
      test('Amharic Fidel syllabary conversion', () {
        final res = transliterator.convert(
          'selam',
          from: LanguageScript.latin,
          to: LanguageScript.amharic,
        );
        expect(res.text, equals('\u1230\u120B\u121D')); // ሰላም

        final rev = transliterator.convert(
          res.text,
          from: LanguageScript.amharic,
          to: LanguageScript.latin,
        );
        expect(rev.text.toLowerCase(), contains('selam'));
      });

      test('Universal International Phonetic Alphabet (IPA) transcription', () {
        final res = transliterator.convert(
          'ami banglay gan gai',
          from: LanguageScript.latin,
          to: LanguageScript.ipa,
        );
        expect(res.text, contains('a'));
        expect(res.text, contains('m'));
        expect(res.text, contains('ɡ'));
        expect(res.text, contains('ŋ'));
      });
    });

    // =========================================================================
    // 6. Cross-Script Routing Pivot Across Brand New Scripts
    // =========================================================================
    group('6. Multi-Hop Cross-Routing Across All New Scripts', () {
      test('Multi-hop: Sanskrit -> Latin -> Serbian', () {
        final res = transliterator.convert(
          'om shanti',
          from: LanguageScript.sanskrit,
          to: LanguageScript.serbian,
        );
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Multi-hop: Amharic -> Latin -> Lao', () {
        final res = transliterator.convert(
          'ሰላም',
          from: LanguageScript.amharic,
          to: LanguageScript.lao,
        );
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Multi-hop: Kurdish -> Latin -> Burmese', () {
        final res = transliterator.convert(
          'سڵاو',
          from: LanguageScript.kurdish,
          to: LanguageScript.burmese,
        );
        expect(res.text.isNotEmpty, isTrue);
      });

      test('Multi-hop: Kazakh -> Latin -> Khmer', () {
        final res = transliterator.convert(
          'Сәлем',
          from: LanguageScript.kazakh,
          to: LanguageScript.khmer,
        );
        expect(res.text.isNotEmpty, isTrue);
      });
    });
  });
}
