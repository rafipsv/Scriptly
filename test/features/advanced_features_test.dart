import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('1. ScriptDetector Precision Tests', () {
    test('detects Bengali script with high confidence', () {
      final res = ScriptDetector.detect('আমি বাংলায় গান গাই');
      expect(res.script, LanguageScript.bengali);
      expect(res.confidence, greaterThanOrEqualTo(0.9));
      expect(res.isReliable, isTrue);
    });

    test('detects Hindi (Devanagari) script', () {
      final res = ScriptDetector.detect('नमस्ते भारत');
      expect(res.script, LanguageScript.hindi);
      expect(res.confidence, 1.0);
    });

    test('detects Georgian Mkhedruli script', () {
      final res = ScriptDetector.detect('გამარჯობა საქართველო');
      expect(res.script, LanguageScript.georgian);
      expect(res.confidence, 1.0);
    });

    test('detects Armenian script', () {
      final res = ScriptDetector.detect('Բարև Հայաստան');
      expect(res.script, LanguageScript.armenian);
      expect(res.confidence, 1.0);
    });

    test('detects Ukrainian Cyrillic correctly distinguishing from Russian', () {
      final res = ScriptDetector.detect('привіт як справи? їж яблуко');
      expect(res.script, LanguageScript.ukrainian);
    });

    test('detects Thai script', () {
      final res = ScriptDetector.detect('สวัสดีครับ');
      expect(res.script, LanguageScript.thai);
      expect(res.confidence, 1.0);
    });

    test('detects Arabic script', () {
      final res = ScriptDetector.detect('مرحبا بك');
      expect(res.script, LanguageScript.arabic);
      expect(res.confidence, 1.0);
    });

    test('detects Hebrew script', () {
      final res = ScriptDetector.detect('שלום עליכם');
      expect(res.script, LanguageScript.hebrew);
      expect(res.confidence, 1.0);
    });

    test('handles empty or whitespace strings gracefully', () {
      final res = ScriptDetector.detect('   12345 !!! ');
      expect(res.isReliable, isFalse);
    });
  });

  group('2. CustomDictionary & Word Overrides', () {
    tearDown(() => CustomDictionary.clear());

    test('applies global custom word overrides before transliteration', () {
      CustomDictionary.register('bKash', 'বিকাশ');
      CustomDictionary.register('Pathao', 'পাঠাও');

      final result = Scriptly.convert(
        'bKash app and Pathao ride',
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
      );

      expect(result.text.contains('বিকাশ'), isTrue);
      expect(result.text.contains('পাঠাও'), isTrue);
    });

    test('per-request customDictionary overrides take priority', () {
      final result = Scriptly.convert(
        'Hello Google',
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
        options: const ConversionOptions(
          customDictionary: {'Google': 'গুগল'},
        ),
      );

      expect(result.text.contains('গুগল'), isTrue);
    });
  });

  group('3. Phonetic Soundex & Cross-Script Similarity', () {
    test('computes similarity between Latin query and native script', () {
      final simBengali = PhoneticMatcher.similarity('dhaka', 'ঢাকা');
      expect(simBengali, greaterThanOrEqualTo(0.70));

      final simHindi = PhoneticMatcher.similarity('namaste', 'नमस्ते');
      expect(simHindi, greaterThanOrEqualTo(0.70));
    });

    test('isMatch correctly filters matching cross-script candidates', () {
      expect(PhoneticMatcher.isMatch('karim', 'করিম'), isTrue);
      expect(PhoneticMatcher.isMatch('rahim', 'রহিম'), isTrue);
      expect(PhoneticMatcher.isMatch('dhaka', 'চট্টগ্রাম'), isFalse);
    });

    test('generates 4-character Soundex code', () {
      final code1 = PhoneticMatcher.soundex('Dhaka');
      final code2 = PhoneticMatcher.soundex('ঢাকা');
      expect(code1.length, 4);
      expect(code2.length, 4);
      expect(code1[0], 'D');
    });
  });

  group('4. Scriptly Unified Facade', () {
    test('Scriptly.autoConvert automatically detects script and converts', () {
      // Auto detects Georgian and converts to Latin
      final res = Scriptly.autoConvert('გამარჯობა', to: LanguageScript.latin);
      expect(res.text.isNotEmpty, isTrue);
      expect(res.from, LanguageScript.georgian);
    });

    test('Scriptly.detect facade matches ScriptDetector', () {
      final det = Scriptly.detect('নমস্কার');
      expect(det.script, LanguageScript.bengali);
    });

    test('Scriptly.similarity and isMatch facades work', () {
      expect(Scriptly.isMatch('salam', 'সালাম'), isTrue);
      expect(Scriptly.similarity('hello', 'hello'), 1.0);
    });
  });

  group('5. Flutter Widgets Verification', () {
    testWidgets('ScriptlySearchField filters items cross-script', (tester) async {
      final cities = ['ঢাকা', 'চট্টগ্রাম', 'সিলেট', 'রাজশাহী'];

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ScriptlySearchField<String>(
            items: cities,
            itemLabel: (c) => c,
            itemBuilder: (ctx, c) => Text(c),
          ),
        ),
      );

      expect(find.text('ঢাকা'), findsOneWidget);
      expect(find.text('সিলেট'), findsOneWidget);
    });

    testWidgets('ScriptlySuggestionOverlay mounts and renders child', (tester) async {
      final controller = TextEditingController(text: 'ami');

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ScriptlySuggestionOverlay(
            controller: controller,
            from: LanguageScript.latin,
            to: LanguageScript.bengali,
            child: const Text('Input Field'),
          ),
        ),
      );

      expect(find.text('Input Field'), findsOneWidget);
    });
  });
}
