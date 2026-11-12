import 'package:flutter_test/flutter_test.dart';
import 'package:scriptly/scriptly.dart';
import 'package:example/src/core/constants/app_constants.dart';

void main() {
  group('Example Web AppConstants Tests', () {
    test('AppConstants has all 41 supported languages configured', () {
      expect(AppConstants.supportedLanguages.length, equals(41));

      final configuredScripts = AppConstants.supportedLanguages
          .map((item) => item['script'] as LanguageScript)
          .toSet();

      expect(configuredScripts.length, equals(41));

      for (final script in LanguageScript.values) {
        expect(
          configuredScripts.contains(script),
          isTrue,
          reason: 'Missing language configuration for ${script.code} (${script.name}) in AppConstants',
        );
      }
    });

    test('Each language has valid metadata (name, code, category)', () {
      for (final item in AppConstants.supportedLanguages) {
        expect(item['name'], isA<String>());
        expect((item['name'] as String).isNotEmpty, isTrue);

        expect(item['code'], isA<String>());
        expect((item['code'] as String).isNotEmpty, isTrue);

        expect(item['category'], isA<String>());
        expect((item['category'] as String).isNotEmpty, isTrue);
      }
    });
  });
}
