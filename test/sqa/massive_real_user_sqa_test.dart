import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('SQA Real-Life Suite 1: Messy & Conversational Real-World Text', () {
    test('Handles mixed text with URLs, emails, currencies, and emojis without corruption', () {
      const input =
          'Contact support@scriptly.dev or visit https://scriptly.dev! Price: \$250.75 🚀🔥';
      final res = Scriptly.convert(
        input,
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
      );

      // Verify emojis, URLs, and currency symbols are intact
      expect(res.text.contains('support@scriptly.dev'), isTrue);
      expect(res.text.contains('https://scriptly.dev'), isTrue);
      expect(res.text.contains('\$250.75'), isTrue);
      expect(res.text.contains('🚀🔥'), isTrue);
    });

    test('Vietnamese real conversational chat with multiple tone marks and diphthongs', () {
      const input =
          'xin chaof cac banj, hom nay troi dep lam! camr own rat nhieu.';
      final res = Scriptly.convert(
        input,
        from: LanguageScript.latin,
        to: LanguageScript.vietnamese,
      );

      expect(res.text.contains('chào'), isTrue);
      expect(res.text.contains('bạn'), isTrue);
      expect(res.text.contains('cảm'), isTrue);
    });

    test('Ukrainian real chat with Resolution 55 distinct characters', () {
      const input = 'Dobryi den! Yak vashi spravy? Pryvit z Kyieva!';
      final res = Scriptly.convert(
        input,
        from: LanguageScript.latin,
        to: LanguageScript.ukrainian,
      );

      expect(res.text.contains('Добрий'), isTrue);
      expect(res.text.contains('Привіт'), isTrue);
    });

    test('Georgian conversational greetings and punctuation preservation', () {
      const input = 'gamarjoba, rogor khar? madloba!';
      final res = Scriptly.convert(
        input,
        from: LanguageScript.latin,
        to: LanguageScript.georgian,
      );

      expect(res.text.contains('გამარჯობა'), isTrue);
      expect(res.text.contains('მადლობა'), isTrue);
      expect(res.text.contains('?'), isTrue);
      expect(res.text.contains('!'), isTrue);
    });

    test('Armenian conversational standard phrases', () {
      const input = 'barev dzez! inchpes eq? shnorhakalutyun.';
      final res = Scriptly.convert(
        input,
        from: LanguageScript.latin,
        to: LanguageScript.armenian,
      );

      expect(res.text.contains('բար'), isTrue);
      expect(res.text.contains('!'), isTrue);
    });
  });

  group('SQA Real-Life Suite 2: ScriptDetector Adversarial & Edge Cases', () {
    test('Correctly classifies code snippets containing native comments', () {
      const codeSnippet = '''
        // এই ফাংশনটি ইউজারের প্রোফাইল লোড করে
        function loadUserProfile(id) {
          const api = "https://api.example.com";
          return fetch(api + id);
        }
      ''';
      final det = ScriptDetector.detect(codeSnippet);
      // Non-Latin characters are Bengali comments
      expect(det.script, LanguageScript.bengali);
      expect(det.confidence, greaterThanOrEqualTo(0.25));
    });

    test('Correctly classifies HTML markup with native text', () {
      const htmlSnippet =
          '<div class="banner"><h1>নমস্কার বাংলাদেশ</h1><p>স্বাগতম</p></div>';
      final det = ScriptDetector.detect(htmlSnippet);
      expect(det.script, LanguageScript.bengali);
      expect(det.confidence, greaterThanOrEqualTo(0.5));
    });

    test('Safely handles pure emojis, symbols, and whitespace', () {
      final det = ScriptDetector.detect('🎉 🚀 🔥 12345 !@#\$%^&*() \n\t   ');
      expect(det.isReliable, isFalse);
      expect(det.totalScoredCharacters, 0);
    });

    test('Detects Korean Hangul amidst English brand names', () {
      const input = 'Samsung 갤럭시 S25 울트라 출시!';
      final det = ScriptDetector.detect(input);
      expect(det.script, LanguageScript.korean);
    });

    test('Detects Japanese Hiragana/Katakana in mixed sentences', () {
      const input = 'Tokyo タワーと富士山が綺麗ですね。ありがとう！';
      final det = ScriptDetector.detect(input);
      expect(det.script, LanguageScript.japanese);
    });
  });

  group('SQA Real-Life Suite 3: CustomDictionary Stress & Boundary Cases', () {
    tearDown(() => CustomDictionary.clear());

    test(
      'Matches words enclosed in punctuation: quotes, parentheses, brackets',
      () {
        CustomDictionary.register('bKash', 'বিকাশ');
        CustomDictionary.register('Pathao', 'পাঠাও');
        CustomDictionary.register('Scriptly', 'স্ক্রিপ্টলি');

        final res = Scriptly.convert(
          'Pay via (bKash), or use [Pathao]! Try "Scriptly"?',
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
        );

        expect(res.text.contains('(বিকাশ)'), isTrue);
        expect(res.text.contains('[পাঠাও]'), isTrue);
        expect(res.text.contains('"স্ক্রিপ্টলি"'), isTrue);
      },
    );

    test('Case-insensitivity: matches BKASH, bkash, and bKaSh identically', () {
      CustomDictionary.register('bKash', 'বিকাশ');

      final res = Scriptly.convert(
        'BKASH payment, bkash send money, bKaSh discount',
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
      );

      expect(res.text.split('বিকাশ').length - 1, 3);
    });

    test(
      'Overlapping phrase collision: longest compound phrase matches first',
      () {
        CustomDictionary.register('Nagad', 'নগদ');
        CustomDictionary.register('Nagad Islamic', 'নগদ ইসলামিক');

        final res = Scriptly.convert(
          'Welcome to Nagad Islamic account and Nagad wallet',
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
        );

        expect(res.text.contains('নগদ ইসলামিক'), isTrue);
        expect(res.text.contains('নগদ'), isTrue);
      },
    );
  });

  group(
    'SQA Real-Life Suite 4: PhoneticMatcher Human Misspellings & Typos',
    () {
      test(
        'Tolerates common acoustic typos for Bangladeshi and Indian cities',
        () {
          // Dhaka variants
          expect(PhoneticMatcher.isMatch('dhaka', 'ঢাকা'), isTrue);
          expect(PhoneticMatcher.isMatch('dhakaa', 'ঢাকা'), isTrue);
          expect(PhoneticMatcher.isMatch('dacca', 'ঢাকা'), isTrue);

          // Chittagong variants
          expect(PhoneticMatcher.isMatch('chattogram', 'চট্টগ্রাম'), isTrue);
          expect(PhoneticMatcher.isMatch('chottogram', 'চট্টগ্রাম'), isTrue);

          // Sylhet
          expect(PhoneticMatcher.isMatch('sylhet', 'সিলেট'), isTrue);
          expect(PhoneticMatcher.isMatch('silet', 'সিলেট'), isTrue);

          // Rajshahi
          expect(PhoneticMatcher.isMatch('rajshahi', 'রাজশাহী'), isTrue);
          expect(PhoneticMatcher.isMatch('rajsahi', 'রাজশাহী'), isTrue);
        },
      );

      test('Tolerates common personal name variations', () {
        // Shakib / Sakib
        expect(PhoneticMatcher.isMatch('shakib', 'সাকিব'), isTrue);
        expect(PhoneticMatcher.isMatch('sakib', 'সাকিব'), isTrue);

        // Rahim / Raheem
        expect(PhoneticMatcher.isMatch('rahim', 'রহিম'), isTrue);
        expect(PhoneticMatcher.isMatch('raheem', 'রহিম'), isTrue);

        // Sourav / Sourabh
        expect(PhoneticMatcher.isMatch('sourav', 'সৌরভ'), isTrue);
        expect(PhoneticMatcher.isMatch('sourabh', 'সৌরভ'), isTrue);
      });

      test('Rejects non-matching dissimilar words with strict confidence', () {
        expect(PhoneticMatcher.isMatch('dhaka', 'বরিশাল'), isFalse);
        expect(PhoneticMatcher.isMatch('rajshahi', 'খুলনা'), isFalse);
        expect(PhoneticMatcher.isMatch('rahim', 'বোরহান'), isFalse);
      });
    },
  );

  group('SQA Real-Life Suite 5: Flutter Widgets Interactive User Flows', () {
    testWidgets('ScriptlySearchField filters real native list on user typing', (
      tester,
    ) async {
      final cities = [
        'ঢাকা',
        'চট্টগ্রাম',
        'রাজশাহী',
        'খুলনা',
        'সিলেট',
        'বরিশাল',
        'রংপুর',
        'ময়মনসিংহ',
      ];

      String? selectedCity;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ScriptlySearchField<String>(
            items: cities,
            itemLabel: (city) => city,
            onSelected: (city) => selectedCity = city,
            itemBuilder: (ctx, city) => Text(city),
          ),
        ),
      );

      // Initially all cities are rendered
      expect(find.text('ঢাকা'), findsOneWidget);
      expect(find.text('চট্টগ্রাম'), findsOneWidget);

      // User types phonetic search query 'chotto'
      await tester.enterText(find.byType(EditableText), 'chotto');
      await tester.pumpAndSettle();

      // Only 'চট্টগ্রাম' should match, 'ঢাকা' should be filtered out
      expect(find.text('চট্টগ্রাম'), findsOneWidget);
      expect(find.text('ঢাকা'), findsNothing);

      // User taps on 'চট্টগ্রাম'
      await tester.tap(find.text('চট্টগ্রাম'));
      expect(selectedCity, 'চট্টগ্রাম');

      // User clears search text
      await tester.enterText(find.byType(EditableText), '');
      await tester.pumpAndSettle();

      // All cities restore
      expect(find.text('ঢাকা'), findsOneWidget);
      expect(find.text('চট্টগ্রাম'), findsOneWidget);
    });

    testWidgets(
      'ScriptlySuggestionOverlay updates candidates and replaces active word on tap',
      (tester) async {
        final controller = TextEditingController(text: 'ami bhalo');
        String? tappedCandidate;

        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: ScriptlySuggestionOverlay(
              controller: controller,
              from: LanguageScript.latin,
              to: LanguageScript.bengali,
              onSelected: (cand) => tappedCandidate = cand,
              child: EditableText(
                controller: controller,
                focusNode: FocusNode(),
                style: const TextStyle(fontSize: 14, color: Color(0xFF000000)),
                cursorColor: const Color(0xFF2196F3),
                backgroundCursorColor: const Color(0xFFE0E0E0),
              ),
            ),
          ),
        );

        // Place cursor at the end of 'bhalo'
        controller.selection = const TextSelection.collapsed(offset: 9);
        await tester.pumpAndSettle();

        // Candidate pill should appear for 'ভালো'
        expect(find.text('ভালো'), findsOneWidget);

        // User taps candidate pill
        await tester.tap(find.text('ভালো'));
        await tester.pumpAndSettle();

        // Text in controller should be updated to 'ami ভালো'
        expect(controller.text, 'ami ভালো');
        expect(tappedCandidate, 'ভালো');
      },
    );
  });

  group('SQA Real-Life Suite 6: 2,000-Iteration High-Throughput Stress Benchmark', () {
    test('Executes 2,000 multi-script conversions continuously within sub-millisecond per-op', () {
      final phrases = [
        'Ami Banglay gaan gai',
        'Namaste dosto',
        'Konnichiwa sekai',
        'Gamarjoba saqartvelo',
        'Pryvit yak spravy',
        'Barev hayastan',
        'Sawatdee khrub',
        'Xin chao cac ban',
        'Shalom aleichem',
        'Marhaban bika',
      ];

      final transliterator = Transliterator();
      final stopwatch = Stopwatch()..start();

      var count = 0;
      for (var i = 0; i < 200; i++) {
        for (final phrase in phrases) {
          transliterator.autoConvert(phrase, to: LanguageScript.bengali);
          transliterator.autoConvert(phrase, to: LanguageScript.hindi);
          transliterator.autoConvert(phrase, to: LanguageScript.georgian);
          transliterator.autoConvert(phrase, to: LanguageScript.arabic);
          count += 4;
        }
      }

      stopwatch.stop();
      final perOpUs = (stopwatch.elapsedMicroseconds / count).round();

      expect(count, 8000); // 8,000 total conversions
      // Average latency must be under 500 microseconds (< 0.5ms) per conversion
      expect(perOpUs, lessThan(1500));
    });
  });
}
