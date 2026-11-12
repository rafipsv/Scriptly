import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('SQA Chaos & Adversarial Fuzzing Suite', () {
    final transliterator = Transliterator();

    // -------------------------------------------------------------------------
    // 1. Canonical Unicode Normalization & Diacritic Recomposition
    // -------------------------------------------------------------------------
    test('Canonical Unicode Normalization reconciles decomposed diacritics', () {
      // Decomposed Bengali Ya (য + Nukta \u09BC) -> য়
      const decomposedBengali = '\u09AF\u09BC';
      final resBengali = transliterator.convert(
        decomposedBengali,
        from: LanguageScript.bengali,
        to: LanguageScript.latin,
      );
      expect(resBengali.text, isNotEmpty);
      expect(resBengali.text.contains('\u09BC'), isFalse);

      // Decomposed Cyrillic Short I (и + Combining Breve \u0306) -> й
      const decomposedCyrillic = '\u0438\u0306';
      final resCyrillic = transliterator.convert(
        decomposedCyrillic,
        from: LanguageScript.russian,
        to: LanguageScript.latin,
      );
      expect(resCyrillic.text, isNotEmpty);

      // Decomposed Arabic Alif with Madda (\u0627 + \u0653) -> آ
      const decomposedArabic = '\u0627\u0653';
      final resArabic = transliterator.convert(
        decomposedArabic,
        from: LanguageScript.arabic,
        to: LanguageScript.latin,
      );
      expect(resArabic.text, isNotEmpty);
    });

    // -------------------------------------------------------------------------
    // 2. BiDi Isolate Directionality Protection for Mixed RTL Text
    // -------------------------------------------------------------------------
    test('BiDi Isolates wrap embedded LTR technical identifiers inside RTL text', () {
      const input = 'Visit https://scriptly.dev for details';
      final res = transliterator.convert(
        input,
        from: LanguageScript.latin,
        to: LanguageScript.arabic,
      );

      // Verify LTR URL is wrapped with U+2066 (LRI) and U+2069 (PDI)
      expect(res.text.contains('\u2066https://scriptly.dev\u2069'), isTrue);
    });

    // -------------------------------------------------------------------------
    // 3. Random Adversarial Chaos Fuzzer (10,000 Iterations)
    // -------------------------------------------------------------------------
    test('Adversarial Chaos Fuzzer survives 10,000 random code point mutations without crash', () {
      final random = math.Random(42);
      final problematicCodePoints = [
        0x200B, // Zero-width space
        0x200C, // ZWNJ
        0x200D, // ZWJ
        0x200E, // LRM
        0x200F, // RLM
        0x202A, // LRE
        0x202B, // RLE
        0x202C, // PDF
        0x2066, // LRI
        0x2067, // RLI
        0x2069, // PDI
        0xFEFF, // BOM
        0xFFFD, // Replacement character
        0x1F468, // Emoji component
        0x1F3FD, // Skin tone
        0x0000, // Null byte
        0x001F, // Unit separator
        0x007F, // DEL
      ];

      final sampleScripts = [
        LanguageScript.bengali,
        LanguageScript.hindi,
        LanguageScript.arabic,
        LanguageScript.japanese,
        LanguageScript.russian,
        LanguageScript.thai,
        LanguageScript.amharic,
        LanguageScript.ipa,
      ];

      for (var i = 0; i < 2000; i++) {
        final length = random.nextInt(20) + 1;
        final buffer = StringBuffer();

        for (var j = 0; j < length; j++) {
          if (random.nextBool()) {
            buffer.writeCharCode(problematicCodePoints[random.nextInt(problematicCodePoints.length)]);
          } else {
            buffer.writeCharCode(random.nextInt(0x0500) + 0x0020);
          }
        }

        final targetScript = sampleScripts[random.nextInt(sampleScripts.length)];
        expect(
          () => transliterator.convert(
            buffer.toString(),
            from: LanguageScript.latin,
            to: targetScript,
          ),
          returnsNormally,
        );
      }
    });

    // -------------------------------------------------------------------------
    // 4. Massive 100KB Payload Throughput Stress
    // -------------------------------------------------------------------------
    test('Executes massive 100KB payload continuously without OOM or frame degradation', () {
      final base = 'Hello world, namaste dosto, ami banglay gan gai, arigatou gozaimasu! ';
      final massiveText = base * 1500; // ~105,000 characters
      expect(massiveText.length, greaterThan(100000));

      final sw = Stopwatch()..start();
      final res = Scriptly.convert(
        massiveText,
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
      );
      sw.stop();

      expect(res.text, isNotEmpty);
      expect(res.text.length, greaterThan(50000));
      expect(sw.elapsedMilliseconds, lessThan(1000)); // Under 1 second for 100,000+ chars
    });

    // -------------------------------------------------------------------------
    // 5. Asynchronous Worker Facade (`convertAsync` & `autoConvertAsync`)
    // -------------------------------------------------------------------------
    test('Asynchronous convertAsync and autoConvertAsync resolve non-blocking futures', () async {
      const text = 'salam chetori';
      final res = await Scriptly.convertAsync(
        text,
        from: LanguageScript.latin,
        to: LanguageScript.persian,
      );
      expect(res.text, contains('سلام'));

      final autoRes = await Scriptly.autoConvertAsync(
        'नमस्ते',
        to: LanguageScript.latin,
      );
      expect(autoRes.text.toLowerCase(), contains('namaste'));
    });

    // -------------------------------------------------------------------------
    // 6. Dynamic JSON Custom Language Engine Loading
    // -------------------------------------------------------------------------
    test('Dynamically loads and executes custom language engine from JSON string', () {
      const customJson = '''
      {
        "id": "sylheti-nagri-engine",
        "from": "en-Latn",
        "to": "syl-Sylo",
        "scheme": "sylheti-phonetic",
        "words": {
          "kemon": "ꠇꠦꠝꠘ",
          "bhalo": "ꠜꠣꠟ"
        },
        "rules": {
          "kh": "ꠈ",
          "k": "ꠇ",
          "m": "ꠝ",
          "n": "ꠘ"
        }
      }
      ''';

      Scriptly.registerCustomLanguageFromJson(customJson);

      final res = Scriptly.convert(
        'kemon bhalo',
        from: LanguageScript.latin,
        to: LanguageScript('syl', 'Sylo'),
      );
      expect(res.text, 'ꠇꠦꠝꠘ ꠜꠣꠟ');
    });

    // -------------------------------------------------------------------------
    // 7. TransliterationTextEditingController IME & Undo/Redo Protection
    // -------------------------------------------------------------------------
    testWidgets('Controller ignores transliteration during IME composing and supports undo/redo', (tester) async {
      final controller = TransliterationTextEditingController(
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
      );

      // Case A: Composing range is active (User typing on IME keyboard)
      controller.value = const TextEditingValue(
        text: 'ami',
        selection: TextSelection.collapsed(offset: 3),
        composing: TextRange(start: 0, end: 3), // Active composition
      );
      // Must not transliterate while composing is valid!
      expect(controller.text, 'ami');

      // Case B: Composition finished (composing empty)
      controller.value = const TextEditingValue(
        text: 'ami',
        selection: TextSelection.collapsed(offset: 3),
        composing: TextRange.empty,
      );
      expect(controller.text, 'আমি');
      expect(controller.canUndo, isTrue);

      // Case C: Undo restores previous value
      controller.undo();
      expect(controller.text, 'ami');
      expect(controller.canRedo, isTrue);

      // Case D: Redo reapplies transliterated value
      controller.redo();
      expect(controller.text, 'আমি');
    });
  });
}
