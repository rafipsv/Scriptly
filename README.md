# Polyglot Transliterator

[![pub package](https://img.shields.io/badge/pub-v0.1.0-blue.svg)](https://pub.dev/packages/polyglot_transliterator)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An extensible, offline-first transliteration package for Flutter and Dart. It converts text between different writing systems (scripts) based on phonetic mappings, starting with Bengali and Latin (Banglish).

---

## Transliteration vs Translation

> **Important distinction:**
> - **Transliteration** converts text between writing systems (alphabets/scripts) while preserving pronunciation according to phonetic rules (e.g. `Ami Banglay likhi` -> Bengali script).
> - **Translation** changes the meaning between different languages (e.g. `Ami bhalo achi` -> `I am fine`).
>
> This package is strictly a **transliteration engine**, not a semantic translator.

---

## Features

- **100% Offline & Private**: Zero API keys, no network calls, no cloud dependencies, and zero analytics.
- **Bidirectional Bengali Support**:
  - Latin/Banglish phonetic typing -> Bengali script (Avro-style phonetic input).
  - Bengali script -> Deterministic Latin romanization.
- **Extensible Architecture**: Layered design with pluggable `TransliteratorEngine` and `EngineRegistry` adhering to BCP-47 (`bn`, `en`) and ISO 15924 (`Beng`, `Latn`).
- **Unicode Safe**: Built with grapheme-cluster awareness (`package:characters`), preserving combining marks, emoji, whitespace, and punctuation.
- **Configurable Digit Policies**: Seamlessly keep ASCII digits or convert them to target script digits.
- **Flutter TextField Integration**: Includes `TransliterationTextEditingController` for live input with selection and cursor position safety.

---

## Installation

Add `polyglot_transliterator` to your `pubspec.yaml`:

```yaml
dependencies:
  polyglot_transliterator: ^0.1.0
```

Then run:

```bash
flutter pub get
```

---

## Quick Start

### 1. Ergonomic Bengali Transliterator

```dart
import 'package:polyglot_transliterator/polyglot_transliterator.dart';

void main() {
  final bn = BengaliTransliterator();

  // Latin / Banglish -> Bengali Script
  final bengaliText = bn.toBengali('Ami Banglay likhi');
  print(bengaliText);

  // Bengali Script -> Latin Romanization
  final romanized = bn.toLatin(bengaliText);
  print(romanized); // Output: Ami Banglay likhi
}
```

### 2. Multi-Script Core Transliterator

```dart
import 'package:polyglot_transliterator/polyglot_transliterator.dart';

void main() {
  final transliterator = Transliterator();

  final result = transliterator.convert(
    'Bangladesh',
    from: LanguageScript.latin,
    to: LanguageScript.bengali,
    options: const ConversionOptions(
      mode: ConversionMode.phonetic,
      digitPolicy: DigitPolicy.convertToTarget,
    ),
  );

  print('Converted: ${result.text}');
  print('Scheme: ${result.scheme}');
}
```

### 3. Flutter Real-time TextField Integration

```dart
import 'package:flutter/material.dart';
import 'package:polyglot_transliterator/polyglot_transliterator.dart';

class MyInputField extends StatefulWidget {
  const MyInputField({super.key});

  @override
  State<MyInputField> createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  late final TransliterationTextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransliterationTextEditingController(
      from: LanguageScript.latin,
      to: LanguageScript.bengali,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        labelText: 'Type in Banglish',
        hintText: 'e.g. Kemon acho',
      ),
    );
  }
}
```

---

## Configuration Options

The `ConversionOptions` class allows customizing transliteration behavior:

| Option | Type | Default | Description |
|---|---|---|---|
| `mode` | `ConversionMode` | `phonetic` | `phonetic`, `romanization`, `strict`, `permissive` |
| `digitPolicy` | `DigitPolicy` | `preserveSource` | `preserveSource` keeps ASCII digits; `convertToTarget` converts to target script digits. |
| `preservePunctuation` | `bool` | `true` | Preserves standard punctuation marks and symbols. |
| `preserveWhitespace` | `bool` | `true` | Preserves spaces, tabs, and newlines. |
| `preserveExistingTargetScript` | `bool` | `true` | Retains existing target-script characters without modifying them. |
| `capitalizationPolicy` | `CapitalizationPolicy` | `preserveSource` | Casing rule for Latin script targets. |

---

## Known Limitations

- **Phonetic Ambiguity**: Natural Banglish typing often has multiple colloquial spellings for the same word. While standard Avro rules and common word dictionaries are included, some uncommon colloquial spellings may yield multiple valid interpretations.
- **Semantic Nuances**: Transliteration does not alter word grammar or sentence structure.

---

## Roadmap

- [ ] Hindi / Devanagari ↔ Latin engine.
- [ ] Arabic ↔ Latin romanization.
- [ ] User-customizable dictionary and rule overrides.
- [ ] Word suggestions / candidate ranking list for IME integrations.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
