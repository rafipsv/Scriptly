# Contributing to Scriptly

Thank you for your interest in contributing to `scriptly`! We welcome contributions from the community to add new language engines, improve phonetic rules, and optimize performance.

---

## Code of Conduct

Please be respectful and constructive in all discussions, issues, and pull requests.

---

## How to Add a New Language Engine

The package is designed with pluggable architecture. To add support for a new language or writing system:

1. **Define the Engine**:
   Create a new engine class inside `lib/src/engines/<group>/` that implements `TransliteratorEngine`:

   ```dart
   import '../../core/conversion_request.dart';
   import '../../core/conversion_result.dart';
   import '../../core/errors.dart';
   import '../../core/language_script.dart';
   import '../../core/transliterator_engine.dart';

   class MyLanguageEngine implements TransliteratorEngine {
     @override
     String get id => 'my-language-engine';

     @override
     String get scheme => 'my-scheme';

     @override
     String get version => '1.0.0';

     @override
     bool supports(LanguageScript from, LanguageScript to) {
       // Return true if this engine handles conversion between from and to
       return ...;
     }

     @override
     ConversionResult convert(ConversionRequest request) {
       // Implement conversion logic
       return ConversionResult(
         text: ...,
         sourceText: request.text,
         from: request.from,
         to: request.to,
         scheme: scheme,
       );
     }
   }
   ```

2. **Register the Engine**:
   Add the new engine instance to `EngineRegistry.withDefaults()` in `lib/src/core/engine_registry.dart`.

3. **Add Constants**:
   Add the BCP-47 and ISO 15924 script constant to `LanguageScript` in `lib/src/core/language_script.dart`.

4. **Write Unit Tests**:
   Add comprehensive test coverage in `test/engines/` covering:
   - Bidirectional conversion
   - Edge cases (whitespace, punctuation, numbers)
   - Proper nouns and common words

5. **Verify Quality**:
   Run the test suite and static analysis before submitting your PR:
   ```bash
   flutter test
   flutter analyze
   dart pub publish --dry-run
   ```

---

## Pull Request Guidelines

- Ensure all existing and new tests pass (`flutter test`).
- Keep code clean with zero analyzer warnings (`flutter analyze`).
- Follow Effective Dart style guidelines.
- Keep controller and BLoC classes concise (under 100 lines).
- Document new public APIs with `///` doc comments.
