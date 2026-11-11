import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polyglot_transliterator/polyglot_transliterator.dart';

void main() {
  group('TransliterationTextEditingController Tests', () {
    test('transliterates text value on update and updates selection', () {
      final controller = TransliterationTextEditingController(
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
      );

      controller.value = const TextEditingValue(
        text: 'Ami',
        selection: TextSelection.collapsed(offset: 3),
      );

      expect(controller.text, '\u0986\u09AE\u09BF');
      expect(controller.selection.baseOffset, '\u0986\u09AE\u09BF'.length);
    });

    test('respects isEnabled flag when toggled', () {
      final controller = TransliterationTextEditingController(
        from: LanguageScript.latin,
        to: LanguageScript.bengali,
        isEnabled: false,
      );

      controller.value = const TextEditingValue(
        text: 'Ami',
        selection: TextSelection.collapsed(offset: 3),
      );

      expect(controller.text, 'Ami');

      controller.toggleEnabled();
      expect(controller.isEnabled, isTrue);

      controller.value = const TextEditingValue(
        text: 'Dhaka',
        selection: TextSelection.collapsed(offset: 5),
      );
      expect(controller.text, '\u09A2\u09BE\u0995\u09BE');
    });
  });
}
