import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly_core.dart';

void main() {
  group('Linguistic Enhancements Module Tests', () {
    test('PunctuationHarmonizer adapts punctuation for Indic scripts', () {
      const text = 'Ami banglay gan gai. Shobai bhalo thakun..';
      final harmonized = Scriptly.harmonizePunctuation(
        text,
        LanguageScript.bengali,
      );

      expect(harmonized.contains('\u0964'), isTrue); // Dari '।'
      expect(harmonized.contains('\u0965'), isTrue); // Double Dari '॥'
    });

    test(
      'PunctuationHarmonizer adapts punctuation for Perso-Arabic scripts',
      () {
        const text = 'Kaise hain aap? Shukriya, bohot accha.';
        final harmonized = Scriptly.harmonizePunctuation(
          text,
          LanguageScript.urdu,
        );

        expect(
          harmonized.contains('\u061F'),
          isTrue,
        ); // Arabic question mark '؟'
        expect(harmonized.contains('\u060C'), isTrue); // Arabic comma '،'
      },
    );

    test('PunctuationHarmonizer adapts Greek question mark', () {
      const text = 'Ti kaneis?';
      final harmonized = Scriptly.harmonizePunctuation(
        text,
        LanguageScript.greek,
      );
      expect(harmonized.contains('\u037E'), isTrue); // Greek question mark ';'
    });

    test('FrequencyTrie ranks candidates by linguistic probability', () {
      final trie = FrequencyTrie.withDefaults();

      final candidates = trie.getCandidates('kori');
      expect(candidates.isNotEmpty, isTrue);
      // 'করি' has frequency 100, should be ranked before 'কড়ি' (frequency 15)
      expect(candidates.first, equals('করি'));
    });
  });
}
