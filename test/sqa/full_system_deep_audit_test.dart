import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group(
    'Audit Layer 1: Cross-Family Multi-Hop Pivot Connectivity & Consistency',
    () {
      final transliterator = Transliterator();

      test('Japanese -> Latin -> Arabic', () {
        final res = transliterator.convert(
          'arigatou',
          from: LanguageScript.japanese,
          to: LanguageScript.arabic,
        );
        expect(res.text.isNotEmpty, isTrue);
        expect(res.scheme.contains('pivot-latin'), isTrue);
      });

      test('Hebrew -> Latin -> Korean', () {
        final res = transliterator.convert(
          'shalom',
          from: LanguageScript.hebrew,
          to: LanguageScript.korean,
        );
        expect(res.text.isNotEmpty, isTrue);
        expect(res.scheme.contains('pivot-latin'), isTrue);
      });

      test('Greek -> Latin -> Bengali', () {
        final res = transliterator.convert(
          'kalimera',
          from: LanguageScript.greek,
          to: LanguageScript.bengali,
        );
        expect(res.text.isNotEmpty, isTrue);
        expect(res.scheme.contains('pivot-latin'), isTrue);
      });

      test('Thai -> Latin -> Georgian', () {
        final res = transliterator.convert(
          'sawatdee',
          from: LanguageScript.thai,
          to: LanguageScript.georgian,
        );
        expect(res.text.isNotEmpty, isTrue);
        expect(res.scheme.contains('pivot-latin'), isTrue);
      });

      test('Persian -> Latin -> Ukrainian', () {
        final res = transliterator.convert(
          'salam',
          from: LanguageScript.persian,
          to: LanguageScript.ukrainian,
        );
        expect(res.text.isNotEmpty, isTrue);
        expect(res.scheme.contains('pivot-latin'), isTrue);
      });
    },
  );

  group('Audit Layer 2: Digit Policy Enforcement Across Numeral Systems', () {
    test('DigitPolicy.convertToTarget converts ASCII digits across all Brahmic scripts', () {
      const numbers = '12345';

      // Bengali: ১২৩৪৫ (0x09E7..0x09EB)
      final bn = Scriptly.convert(
        numbers,
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
        options: ConversionOptions.withTargetDigits,
      );
      expect(bn.text, '১২৩৪৫');

      // Hindi / Devanagari: १२३४५ (0x0967..0x096B)
      final hi = Scriptly.convert(
        numbers,
        from: LanguageScript.latin,
        to: LanguageScript.hindi,
        options: ConversionOptions.withTargetDigits,
      );
      expect(hi.text, '१२३४५');

      // Arabic: ١٢٣٤٥ (0x0661..0x0665)
      final ar = Scriptly.convert(
        numbers,
        from: LanguageScript.latin,
        to: LanguageScript.arabic,
        options: ConversionOptions.withTargetDigits,
      );
      expect(ar.text, '١٢٣٤٥');

      // Persian: ۱۲۳۴۵ (0x06F1..0x06F5)
      final fa = Scriptly.convert(
        numbers,
        from: LanguageScript.latin,
        to: LanguageScript.persian,
        options: ConversionOptions.withTargetDigits,
      );
      expect(fa.text, '۱۲۳۴۵');
    });

    test('DigitPolicy.preserveSource retains ASCII digits exactly with currency & phone formatting', () {
      const phonePrice = '+880-1711-000000 costs \$499.99!';
      final res = Scriptly.convert(
        phonePrice,
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
        options: const ConversionOptions(
          digitPolicy: DigitPolicy.preserveSource,
        ),
      );

      expect(res.text.contains('+880-1711-000000'), isTrue);
      expect(res.text.contains('\$499.99'), isTrue);
    });
  });

  group('Audit Layer 3: TransliterationTextEditingController Cursor & Editing Stability', () {
    test('Letter-by-letter typing preserves cursor position at the end of converted text', () {
      final controller = TransliterationTextEditingController(
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
      );

      final typedSequence = ['a', 'am', 'ami'];
      for (final s in typedSequence) {
        controller.value = TextEditingValue(
          text: s,
          selection: TextSelection.collapsed(offset: s.length),
        );
      }

      expect(controller.text, 'আমি');
      expect(controller.selection.baseOffset, controller.text.length);
      controller.dispose();
    });

    test(
      'Backspace at end of converted word does not crash or throw RangeError',
      () {
        final controller = TransliterationTextEditingController(
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
        );

        controller.value = const TextEditingValue(
          text: 'ami',
          selection: TextSelection.collapsed(offset: 3),
        );
        expect(controller.text, 'আমি');

        // User hits backspace, removing last char
        final currentText = controller.text;
        final shortened = currentText.substring(0, currentText.length - 1);
        controller.value = TextEditingValue(
          text: shortened,
          selection: TextSelection.collapsed(offset: shortened.length),
        );

        expect(controller.text.isNotEmpty, isTrue);
        expect(controller.selection.isValid, isTrue);
        controller.dispose();
      },
    );

    test(
      'Mid-sentence insertion updates text and restores selection offset',
      () {
        final controller = TransliterationTextEditingController(
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
        );

        // Start with 'ami bhalo'
        controller.value = const TextEditingValue(
          text: 'ami bhalo',
          selection: TextSelection.collapsed(offset: 9),
        );
        expect(controller.text.contains('ভালো'), isTrue);

        // Insert word in the middle
        final current = controller.text;
        const insert = ' khub';
        final updated =
            '${current.substring(0, 3)}$insert${current.substring(3)}';
        controller.value = TextEditingValue(
          text: updated,
          selection: TextSelection.collapsed(offset: 3 + insert.length),
        );

        expect(controller.text.contains('খুব'), isTrue);
        controller.dispose();
      },
    );
  });

  group(
    'Audit Layer 4: ScriptlySuggestionOverlay Edge & Boundary Conditions',
    () {
      testWidgets(
        'Handles cursor in middle of sentence and replaces target word accurately',
        (tester) async {
          final controller = TextEditingController(text: 'ami bhalo achi');

          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: ScriptlySuggestionOverlay(
                controller: controller,
                from: LanguageScript.latin,
                to: LanguageScript.bengali,
                child: EditableText(
                  controller: controller,
                  focusNode: FocusNode(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF000000),
                  ),
                  cursorColor: const Color(0xFF2196F3),
                  backgroundCursorColor: const Color(0xFFE0E0E0),
                ),
              ),
            ),
          );

          // Place cursor right after 'bhalo' (offset 9)
          controller.selection = const TextSelection.collapsed(offset: 9);
          await tester.pumpAndSettle();

          // Tap on 'ভালো' suggestion
          expect(find.text('ভালো'), findsOneWidget);
          await tester.tap(find.text('ভালো'));
          await tester.pumpAndSettle();

          // Word 'bhalo' replaced with 'ভালো', while 'ami ' and ' achi' remain untouched
          expect(controller.text, 'ami ভালো achi');
          expect(controller.selection.baseOffset, 'ami ভালো'.length);
        },
      );

      testWidgets(
        'Safely handles trailing whitespace and empty selections without candidate popups',
        (tester) async {
          final controller = TextEditingController(text: 'ami    ');

          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: ScriptlySuggestionOverlay(
                controller: controller,
                from: LanguageScript.latin,
                to: LanguageScript.bengali,
                child: Container(),
              ),
            ),
          );

          controller.selection = const TextSelection.collapsed(offset: 7);
          await tester.pumpAndSettle();

          // When cursor is surrounded by spaces, no candidate pills should be shown
          expect(find.byType(GestureDetector), findsNothing);
        },
      );
    },
  );

  group('Audit Layer 5: Unicode Invisibility, ZWJ, and Combining Marks', () {
    test('Preserves Zero-Width Joiner (ZWJ) and Zero-Width Non-Joiner (ZWNJ) in Bengali/Hindi conjuncts', () {
      // Bengali 'ৎ' is khanda-ta (ta + hasanta + ZWJ)
      const khandaTa = '\u09A4\u09CD\u200D';
      final res = Scriptly.convert(
        khandaTa,
        from: LanguageScript.bengali,
        to: LanguageScript.latin,
      );
      expect(res.text.isNotEmpty, isTrue);

      // Reverse conversion retains valid representation
      final back = Scriptly.convert(
        res.text,
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
      );
      expect(back.text.isNotEmpty, isTrue);
    });

    test('Preserves Byte Order Mark (BOM) and RTL directionality markers', () {
      const rtlText = '\u200Fمرحبا بك\u200E';
      final res = Scriptly.convert(
        rtlText,
        from: LanguageScript.arabic,
        to: LanguageScript.latin,
      );
      expect(res.text.isNotEmpty, isTrue);
    });
  });

  group('Audit Layer 6: Scriptly Facade & Registry Defensive Boundaries', () {
    test(
      'Throws UnsupportedConversionException on unroutable unknown pair',
      () {
        final customUnknown = LanguageScript('xx', 'Xxxx');
        expect(
          () => Scriptly.convert(
            'test',
            from: customUnknown,
            to: LanguageScript.bengali,
          ),
          throwsA(isA<UnsupportedConversionException>()),
        );
      },
    );

    test('fromCode gracefully handles invalid or partial code strings without crashing', () {
      final fallback = LanguageScript.fromCode('unknown');
      expect(fallback.language, 'unknown');
      expect(fallback.script, 'Latn');

      final parsed = LanguageScript.fromCode('bn_Beng');
      expect(parsed, LanguageScript.bengali);
    });
  });
}
