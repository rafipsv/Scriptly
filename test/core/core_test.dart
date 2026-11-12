import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';

void main() {
  group('LanguageScript Tests', () {
    test('creates and normalizes language and script', () {
      const ls = LanguageScript('BN ', ' beng ');
      expect(ls.normalizedLanguage, 'bn');
      expect(ls.normalizedScript, 'Beng');
      expect(ls.toString(), 'BN - beng ');
    });

    test('equality and hashCode match normalized values', () {
      const ls1 = LanguageScript('bn', 'Beng');
      const ls2 = LanguageScript('BN', 'beng');
      expect(ls1, equals(ls2));
      expect(ls1.hashCode, equals(ls2.hashCode));
    });

    test('constants represent intended scripts', () {
      expect(LanguageScript.bengali.language, 'bn');
      expect(LanguageScript.bengali.script, 'Beng');
      expect(LanguageScript.latin.language, 'en');
      expect(LanguageScript.latin.script, 'Latn');
    });
  });

  group('EngineRegistry Tests', () {
    test('withDefaults registers BengaliEngine', () {
      final registry = EngineRegistry.withDefaults();
      expect(registry.registeredEngines, isNotEmpty);
      final engine = registry.findEngine(
        LanguageScript.latin,
        LanguageScript.bengali,
      );
      expect(engine, isNotNull);
      expect(engine!.id, 'bengali-phonetic-engine');
    });

    test('register and unregister', () {
      final registry = EngineRegistry();
      expect(registry.registeredEngines, isEmpty);

      final engine = BengaliEngine();
      registry.register(engine);
      expect(registry.registeredEngines.length, 1);

      registry.unregister(engine.id);
      expect(registry.registeredEngines, isEmpty);
    });
  });

  group('Transliterator Core Tests', () {
    final transliterator = Transliterator();

    test('throws UnsupportedConversionException for unsupported pair', () {
      const unsupported = LanguageScript('xx', 'Xxxx');
      expect(
        () => transliterator.convert(
          'hello',
          from: unsupported,
          to: LanguageScript.latin,
        ),
        throwsA(isA<UnsupportedConversionException>()),
      );
    });

    test('canConvert returns true for supported pairs and false otherwise', () {
      expect(
        transliterator.canConvert(LanguageScript.latin, LanguageScript.bengali),
        isTrue,
      );
      expect(
        transliterator.canConvert(LanguageScript.bengali, LanguageScript.latin),
        isTrue,
      );
      expect(
        transliterator.canConvert(
          LanguageScript.latin,
          const LanguageScript('xx', 'Xxxx'),
        ),
        isFalse,
      );
    });
  });
}
