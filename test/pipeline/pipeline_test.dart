import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly_core.dart';

void main() {
  group('Pipeline & Tooling Module Tests', () {
    test(
      'ScriptlyStreamTransformer processes text chunks asynchronously',
      () async {
        final inputController = StreamController<String>();

        final transformedStream = inputController.stream.transform(
          Scriptly.streamTransformer(
            from: LanguageScript.latin,
            to: LanguageScript.bengali,
          ),
        );

        final results = <String>[];
        transformedStream.listen(results.add);

        inputController.add('ami');
        inputController.add('banglay');
        inputController.add('gan');
        await inputController.close();

        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(results.length, equals(3));
        expect(results[0], equals('আমি'));
        expect(results[1], equals('বাংলায়'));
        expect(results[2], equals('গান'));
      },
    );

    test(
      'MarkdownTransliterator preserves code blocks, inline code, and URLs',
      () {
        const markdown = '''
# Welcome to Scriptly
Here is inline code `final x = 42;` and a raw URL https://github.com/rafipsv/Scriptly.
Check [Official Repo](https://github.com/rafipsv/Scriptly) for updates.

```dart
void main() {
  print("Hello World");
}
```
<span>HTML intact</span>
ami banglay gan gai.
''';

        final result = Scriptly.convertMarkdown(
          markdown,
          from: LanguageScript.latin,
          to: LanguageScript.bengali,
        );

        // Verify code block is 100% intact
        expect(
          result.contains(
            '```dart\nvoid main() {\n  print("Hello World");\n}\n```',
          ),
          isTrue,
        );

        // Verify inline code is intact
        expect(result.contains('`final x = 42;`'), isTrue);

        // Verify URLs are intact
        expect(result.contains('https://github.com/rafipsv/Scriptly'), isTrue);
        expect(
          result.contains('(https://github.com/rafipsv/Scriptly)'),
          isTrue,
        );

        // Verify HTML tag intact
        expect(result.contains('<span>'), isTrue);
        expect(result.contains('</span>'), isTrue);

        // Verify human text was transliterated
        expect(result.contains('আমি বাংলায় গান গাই'), isTrue);
      },
    );

    test('LanguagePackManager exports, compresses, and imports .scriptly binary packs', () {
      const customEngineJson = '''
      {
        "id": "elvish-custom-pack",
        "scheme": "elvish-scheme",
        "from": "en-Latn",
        "to": "art-Elvn",
        "words": {
          "star": "el",
          "friend": "mellon"
        }
      }
      ''';

      // 1. Export pack to compressed binary
      final packBytes = LanguagePackManager.exportPack(customEngineJson);
      expect(packBytes.length, greaterThan(4));
      // Verify header magic "SPLY"
      expect(packBytes[0], equals(0x53));
      expect(packBytes[1], equals(0x50));
      expect(packBytes[2], equals(0x4C));
      expect(packBytes[3], equals(0x59));

      // 2. Import into registry
      final registry = EngineRegistry();
      final engine = LanguagePackManager.importPack(
        packBytes,
        registry: registry,
      );

      expect(engine.id, equals('elvish-custom-pack'));
      expect(
        registry.registeredEngines.any((e) => e.id == 'elvish-custom-pack'),
        isTrue,
      );

      final transliterator = Transliterator(registry: registry);
      final res = transliterator.convert(
        'star friend',
        from: LanguageScript.latin,
        to: const LanguageScript('art', 'Elvn'),
      );
      expect(res.text, equals('el mellon'));
    });
  });
}
