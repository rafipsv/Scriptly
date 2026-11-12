# Scriptly

[![pub package](https://img.shields.io/pub/v/scriptly.svg?logo=dart&logoColor=white)](https://pub.dev/packages/scriptly)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-flutter%20%7C%20dart%20vm%20%7C%20web-blue.svg)](https://pub.dev/packages/scriptly)
[![Test Suite](https://img.shields.io/badge/tests-170%20passed%20%7C%20100%25-brightgreen.svg)](test/)
[![Live Demo](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-2ea44f?logo=github&logoColor=white)](https://rafipsv.github.io/Scriptly)

> 🌐 **Try it Live in your Browser:** **[https://rafipsv.github.io/Scriptly](https://rafipsv.github.io/Scriptly)**

An extensible, high-performance, offline-first multi-language transliteration engine for Flutter and Dart. Converts text seamlessly between **41 writing systems (scripts)** with **1,681 auto-pivot conversion paths**, zero cloud dependencies, and sub-millisecond execution.

Includes an out-of-the-box responsive **Google Translate-style Web application** (`example/`) architected with **Clean Architecture**, **BLoC**, and real-time **Searchable Language Dropdown Pickers**.

---

## Transliteration vs Translation

> [!IMPORTANT]
> - **Transliteration** converts text between writing systems (scripts/alphabets) while preserving acoustic phonetic pronunciation according to language rules (e.g., `Ami Banglay gaan gai` ➔ Bengali phonetic script, `namaste` ➔ Devanagari script).
> - **Translation** alters semantic word meanings into another spoken language (e.g., `Ami bhalo achi` ➔ `I am fine`).
>
> This package is strictly an **offline phonetic transliteration engine**, not an AI or dictionary-based semantic translator.

---

## Key Features

- **100% Offline & Private**: Zero network requests, zero telemetry, zero API keys. Everything runs in-memory on the client.
- **41 Supported Languages & Scripts**: Covers South Asian (Brahmic), Southeast Asian (Indochina), East Asian, Middle Eastern (Perso-Arabic), European/Slavic, African (Ge'ez Fidel), Caucasus, and Universal Phonetic (IPA) families.
- **Universal Auto-Pivot Routing**: Any-to-Any hub-and-spoke conversion routing through phonetic Latin bridges ($41 \times 41 = 1,681$ conversion routes).
- **Direct Brahmic Bridge**: Zero-latency direct cross-script alignment between Indic scripts (Devanagari, Bengali, Gurmukhi, Gujarati, Tamil, Telugu, Malayalam, Kannada, Odia, Sinhala) without intermediary romanization.
- **Extended Indic & Sanskrit**: IAST (International Alphabet of Sanskrit Transliteration) and Harvard-Kyoto support, Marathi retroflex lateral Lla (`ळ`), Nepali orthography, and Assamese Ro (`ৰ`) / Wo (`ৱ`).
- **South Slavic Vuk ↔ Gaj Bi-directional Engine**: Exact 1:1 bi-directional Serbian Cyrillic ↔ Latin mapping, Bulgarian Transliteration Act 2009, Macedonian Cyrillic, and Belarusian Lacinka.
- **Indochina Writing Systems**: UNGEGN Lao, Myanmar / Burmese (MLC / ISO 11940 with tall aa normalization), and Khmer / Cambodian.
- **Central Asian & Kurdish**: Hawar Latin ↔ Sorani Kurdish, Afghan Pashto, and official Kazakhstan 2021 Modern Latin standard.
- **African Semitic & Universal IPA**: Ethiopian Semitic Ge'ez Fidel syllabary (`am-Ethi`) and bi-directional acoustic International Phonetic Alphabet (`und-Zyyy` / IPA).
- **Vietnamese Telex Engine**: Full support for standard Telex typing (`aa` ➔ `â`, `w` ➔ `ư`, `dd` ➔ `đ`) and tone marks (`s, f, r, x, j`).
- **Thai RTGS Transcription**: Phonetic Latin ↔ Thai script conversion based on the Royal Thai General System.
- **Unique World Alphabets**: 1:1 deterministic phonetic mapping for Georgian (Mkhedruli National System 2002), Armenian (ISO 9985), and Ukrainian (Resolution 55).
- **Searchable Language Selection**: Web demo includes real-time searchable modal sheets for instant language filtering by name, script code, or category.
- **Unicode Grapheme Safe**: Grapheme cluster handling (`package:characters`), preserving emojis, symbols, whitespace, and combining diacritic marks.
- **Configurable Digit Policies**: Easily keep ASCII numbers (`1, 2, 3`) or convert to native target script digits across all numeral systems.
- **Flutter TextField Integration**: Includes `TransliterationTextEditingController` for real-time transliteration with selection and cursor stability.
- **Sub-millisecond Latency**: Optimized longest-match Trie algorithms and direct lookup maps benchmarked at `< 0.05ms` per operation.

---

## Supported Languages & Scripts Matrix

| Group | Language | BCP-47 / Script | Direct Scheme / Engine |
|---|---|---|---|
| **Global** | Latin / Roman | `en-Latn` | Phonetic Hub & Pivot Anchor |
| **South Asian (Indic)** | Bengali | `bn-Beng` | Avro-style Phonetic Parser & Deterministic Romanizer |
| **South Asian (Indic)** | Hindi (Devanagari) | `hi-Deva` | Hinglish Phonetic & Harvard-Kyoto Harmonizer |
| **South Asian (Indic)** | Sanskrit | `sa-Deva` | IAST & Harvard-Kyoto Sanskrit Engine |
| **South Asian (Indic)** | Marathi | `mr-Deva` | Devanagari Retroflex Lateral Lla Engine |
| **South Asian (Indic)** | Nepali | `ne-Deva` | Nepali Devanagari Standard Engine |
| **South Asian (Indic)** | Assamese | `as-Beng` | Eastern Indic Ro (`ৰ`) & Wo (`ৱ`) Engine |
| **South Asian (Indic)** | Gujarati | `gu-Gujr` | Gujlish Phonetic & Brahmic Slot Matrix |
| **South Asian (Indic)** | Punjabi (Gurmukhi) | `pa-Guru` | Roman Punjabi & Brahmic Slot Matrix |
| **South Asian (Indic)** | Tamil | `ta-Taml` | Tanglish Phonetic & Brahmic Slot Matrix |
| **South Asian (Indic)** | Telugu | `te-Telu` | Tenglish Phonetic & Brahmic Slot Matrix |
| **South Asian (Indic)** | Malayalam | `ml-Mlym` | Manglish Phonetic & Brahmic Slot Matrix |
| **South Asian (Indic)** | Kannada | `kn-Knda` | Kannada Phonetic & Brahmic Slot Matrix |
| **South Asian (Indic)** | Odia / Oriya | `or-Orya` | Odia Phonetic & Brahmic Slot Matrix |
| **South Asian (Indic)** | Sinhala | `si-Sinh` | Sinhala Phonetic & Brahmic Slot Matrix |
| **Southeast Asian** | Vietnamese | `vi-Latn` | Standard Telex Input Method & Accent Stripper |
| **Southeast Asian** | Thai | `th-Thai` | RTGS (Royal Thai General System) Engine |
| **Southeast Asian** | Lao | `lo-Laoo` | UNGEGN Lao Phonetic Engine |
| **Southeast Asian** | Burmese / Myanmar | `my-Mymr` | MLC / ISO 11940 Tall Aa Normalized Engine |
| **Southeast Asian** | Khmer / Cambodian | `km-Khmr` | UNGEGN Khmer Geographic Names Engine |
| **Middle Eastern** | Arabic | `ar-Arab` | Arabizi / Roman Arabic Phonetic Engine |
| **Middle Eastern** | Urdu | `ur-Arab` | Roman Urdu Phonetic Engine |
| **Middle Eastern** | Persian (Farsi) | `fa-Arab` | Finglish Phonetic & Perso-Arabic Harmonizer |
| **Middle Eastern** | Hebrew | `he-Hebr` | Roman Hebrew ↔ Square Hebrew Script |
| **Middle Eastern** | Kurdish | `ku-Arab` | Hawar Latin ↔ Sorani Arabic Engine |
| **Middle Eastern** | Pashto | `ps-Arab` | Afghan Perso-Arabic Extended Engine |
| **Middle Eastern** | Kazakh | `kk-Cyrl` | Kazakhstan 2021 Modern Latin Standard Engine |
| **East Asian** | Japanese | `ja-Jpan` | Modified Hepburn Romaji ↔ Hiragana / Katakana |
| **East Asian** | Korean | `ko-Hang` | Revised Romanization ↔ Hangul Syllables |
| **East Asian** | Chinese Pinyin | `zh-Latn` | Numeric Pinyin Tones ➔ Diacritics (`ni3 hao3` ➔ `nǐ hǎo`) |
| **European / Slavic** | Russian | `ru-Cyrl` | Latin ↔ Cyrillic (ISO 9 standard) |
| **European / Slavic** | Ukrainian | `uk-Cyrl` | Ukrainian Cyrillic (Resolution 55 / ISO 9) |
| **European / Slavic** | Serbian | `sr-Cyrl` | Vuk's Cyrillic ↔ Gaj's Latin 1:1 Bi-directional |
| **European / Slavic** | Bulgarian | `bg-Cyrl` | Bulgarian Transliteration Act 2009 Engine |
| **European / Slavic** | Macedonian | `mk-Cyrl` | Macedonian Cyrillic Standard Engine |
| **European / Slavic** | Belarusian | `be-Cyrl` | Belarusian Lacinka Standard Engine |
| **European / Slavic** | Greek | `el-Grek` | Greeklish ↔ Greek Alphabet (ISO 843 standard) |
| **Caucasus & World** | Georgian | `ka-Geor` | Mkhedruli Script (National System 2002) |
| **Caucasus & World** | Armenian | `hy-Armn` | Armenian Alphabet (ISO 9985 standard) |
| **African** | Amharic / Ge'ez | `am-Ethi` | Ethiopian Semitic Fidel Syllabary Matrix |
| **Phonetic & Academic** | IPA | `und-Zyyy` | International Phonetic Alphabet Bi-directional |

---

## Installation

Add `scriptly` to your `pubspec.yaml`:

```yaml
dependencies:
  scriptly: ^0.5.0
```

Then fetch the dependencies:

```bash
flutter pub get
# or for pure Dart projects:
dart pub get
```

---

## Quick Start

### 1. Universal Transliterator (Any-to-Any)

```dart
import 'package:scriptly/scriptly.dart';

void main() {
  final transliterator = Transliterator();

  // Latin -> Hindi (Devanagari)
  final hindiRes = transliterator.convert(
    'namaste',
    from: LanguageScript.latin,
    to: LanguageScript.hindi,
  );
  print(hindiRes.text); // Hindi script output

  // Latin -> Japanese (Hiragana)
  final jaRes = transliterator.convert(
    'arigatou',
    from: LanguageScript.latin,
    to: LanguageScript.japanese,
  );
  print(jaRes.text); // Japanese Kana output

  // Latin -> Russian (Cyrillic)
  final ruRes = transliterator.convert(
    'privet',
    from: LanguageScript.latin,
    to: LanguageScript.russian,
  );
  print(ruRes.text); // Cyrillic output
}
```

### 2. Automatic Script Detection & Auto-Convert

Detect scripts automatically or convert without explicitly specifying the source script:

```dart
import 'package:scriptly/scriptly.dart';

void main() {
  // 1. Detect any script and inspect confidence:
  final detection = Scriptly.detect('გამარჯობა');
  print(detection.script.name); // Georgian
  print(detection.confidence);  // 1.0

  // 2. Auto-convert from detected script:
  final autoRes = Scriptly.autoConvert('নমস্কার', to: LanguageScript.kannada);
  print(autoRes.text); // Kannada output
}
```

### 3. Custom Dictionary & Word Overrides

Inject brand names, jargon, or acronyms globally or per request:

```dart
import 'package:scriptly/scriptly.dart';

void main() {
  // Register global domain terms
  Scriptly.setCustomDictionary({
    'bKash': 'বিকাশ',
    'Pathao': 'পাঠাও',
  });

  final res = Scriptly.convert(
    'Use bKash and Pathao',
    from: LanguageScript.latin,
    to: LanguageScript.bengali,
  );
  print(res.text); // Uses 'বিকাশ' and 'পাঠাও'
}
```

### 4. Cross-Script Phonetic Matcher & Soundex

Search native script records using Latin queries:

```dart
import 'package:scriptly/scriptly.dart';

void main() {
  // Check similarity between Latin query and native script (0.0 to 1.0)
  final sim = Scriptly.similarity('dhaka', 'ঢাকা'); // >= 0.85

  // Fast boolean fuzzy match for search bars
  final isMatch = Scriptly.isMatch('karim', 'করিম'); // true

  // Standard 4-character phonetic Soundex hash
  final hash = Scriptly.soundex('ঢাকা'); // 'D200'
}
```

### 5. CLI Command-Line Tool

Use Scriptly directly from your terminal:

```bash
# Convert text:
dart run scriptly convert -t bn "Ami bhalo achi"

# Auto-detect script:
dart run scriptly detect "নমস্কার বাংলাদেশ"

# Convert entire files:
dart run scriptly file -i input.txt -o output.txt -t hi

# List all supported scripts:
dart run scriptly list
```

### 6. Auto-Pivot Cross-Script Routing

Convert between languages across different language families without direct pairwise engines:

```dart
import 'package:scriptly/scriptly.dart';

void main() {
  final transliterator = Transliterator();

  // Russian Cyrillic -> Latin -> Urdu
  final res = transliterator.convert(
    'privet',
    from: LanguageScript.russian,
    to: LanguageScript.urdu,
  );

  print('Result: ${res.text}');
  print('Routing Scheme: ${res.scheme}'); 
  // Scheme: pivot-latin (latin-to-cyrillic -> roman-to-urdu)
}
```

### 3. Direct Zero-Latency Brahmic Bridge

Direct Indic cross-script alignment without passing through Latin romanization:

```dart
import 'package:scriptly/scriptly.dart';

void main() {
  final transliterator = Transliterator();

  // Devanagari Ka -> Bengali Ka
  final result = transliterator.convert(
    '\u0915',
    from: LanguageScript.hindi,
    to: LanguageScript.bengali,
  );

  print(result.text); // Direct Bengali Ka (\u0995)
}
```

### 4. Real-time Flutter TextField Integration

Use `TransliterationTextEditingController` for live as-you-type transliteration inside standard `TextField` or `TextFormField` widgets:

```dart
import 'package:flutter/material.dart';
import 'package:scriptly/scriptly.dart';

class MyTransliterationField extends StatefulWidget {
  const MyTransliterationField({super.key});

  @override
  State<MyTransliterationField> createState() => _MyTransliterationFieldState();
}

class _MyTransliterationFieldState extends State<MyTransliterationField> {
  late final TransliterationTextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransliterationTextEditingController(
      from: LanguageScript.latin,
      to: LanguageScript.bengali,
      options: const ConversionOptions(
        digitPolicy: DigitPolicy.preserveSource,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Type phonetically in English/Banglish',
            hintText: 'e.g. Ami Banglay gaan gai',
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: _controller.canUndo ? () => _controller.undo() : null,
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: _controller.canRedo ? () => _controller.redo() : null,
            ),
          ],
        ),
      ],
    );
  }
}
```

### 5. Background Async Worker (Zero UI Frame Drops)

For large documents, bulk text, or background pipelines, use `convertAsync` to execute via Flutter/Dart background workers (isolates):

```dart
import 'package:scriptly/scriptly.dart';

void main() async {
  // Transliterate 100KB+ documents asynchronously
  final result = await Scriptly.convertAsync(
    largeTextPayload,
    from: LanguageScript.latin,
    to: LanguageScript.bengali,
  );
  print(result.text);

  // Auto-detect and convert in background
  final autoResult = await Scriptly.autoConvertAsync(
    largeTextPayload,
    to: LanguageScript.hindi,
  );
  print(autoResult.text);
}
```

### 6. Dynamic Custom JSON Engines

Register custom language dialects, regional orthographies, or specialized transliteration systems at runtime without recompiling the library:

```dart
import 'package:scriptly/scriptly.dart';

void main() {
  const customJson = '''
  {
    "id": "elvish-engine",
    "supportedPairs": [
      {"from": "en-Latn", "to": "art-Elvn"}
    ],
    "mappings": {
      "hello": "elen",
      "star": "el"
    }
  }
  ''';

  Scriptly.registerCustomLanguageFromJson(customJson);
}
```

---

## Configuration Options

Fine-tune transliteration behavior using `ConversionOptions`:

```dart
final options = ConversionOptions(
  mode: ConversionMode.phonetic,
  digitPolicy: DigitPolicy.convertToTarget,
  preserveWhitespace: true,
  preservePunctuation: true,
  preserveExistingTargetScript: true,
  capitalizationPolicy: CapitalizationPolicy.preserveSource,
);
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `mode` | `ConversionMode` | `phonetic` | `phonetic`, `romanization`, `strict`, `permissive` |
| `digitPolicy` | `DigitPolicy` | `preserveSource` | `preserveSource` retains standard ASCII digits; `convertToTarget` converts digits into target script numbers. |
| `preserveWhitespace` | `bool` | `true` | Preserves spaces, tabs, and newlines exactly as entered. |
| `preservePunctuation` | `bool` | `true` | Preserves standard punctuation, symbols, and emojis. |
| `preserveExistingTargetScript`| `bool` | `true` | Leaves existing target-script characters untouched without alteration. |
| `capitalizationPolicy` | `CapitalizationPolicy` | `preserveSource` | Output casing policy for Latin script targets. |

---

## Architecture

The package follows clean modular boundaries separating core contracts from script-specific phonetic engines:

```
lib/
├── scriptly.dart                      # Unified public API export
└── src/
    ├── core/                          # Contracts, Models, Auto-Pivot Routing
    │   ├── conversion_options.dart
    │   ├── conversion_request.dart
    │   ├── conversion_result.dart
    │   ├── engine_registry.dart       # Extensible engine registry
    │   ├── errors.dart
    │   ├── language_script.dart       # BCP-47 & ISO 15924 standards
    │   ├── transliterator.dart        # Auto-pivot hub
    │   └── transliterator_engine.dart # Engine interface
    ├── engines/                       # 11 Modular Conversion Engines
    │   ├── bengali/                   # Bengali phonetic & Romanizer
    │   ├── hindi/                     # Devanagari phonetic & Romanizer
    │   ├── indic/                     # Universal Indic (Gujr, Guru, Taml, Telu, Mlym)
    │   ├── indic_bridge/              # Direct Brahmic cross-script slot mapper
    │   ├── perso_arabic/              # Arabic, Urdu, Persian & Harmonizer
    │   ├── middle_eastern/            # Hebrew square script
    │   ├── east_asian/                # Japanese Kana, Korean Hangul, Pinyin
    │   └── european/                  # Russian Cyrillic & Greek
    ├── unicode/                       # Grapheme clusters & code-point utilities
    └── widgets/                       # Flutter TextEditingController integration
```

---

## Extending With Custom Engines

Creating a custom transliteration engine is straightforward. Implement `TransliteratorEngine` and register it with `EngineRegistry`:

```dart
import 'package:scriptly/scriptly.dart';

class EsperantoEngine implements TransliteratorEngine {
  @override
  String get id => 'esperanto-x-system';

  @override
  String get scheme => 'x-system-to-circumflex';

  @override
  String get version => '1.0.0';

  @override
  bool supports(LanguageScript from, LanguageScript to) {
    return from.normalizedLanguage == 'eo' && to.normalizedLanguage == 'eo';
  }

  @override
  ConversionResult convert(ConversionRequest request) {
    final converted = request.text
        .replaceAll('cx', 'ĉ')
        .replaceAll('gx', 'ĝ')
        .replaceAll('sx', 'ŝ');

    return ConversionResult(
      text: converted,
      sourceText: request.text,
      from: request.from,
      to: request.to,
      scheme: scheme,
    );
  }
}

// Registration
void main() {
  final registry = EngineRegistry.withDefaults();
  registry.register(EsperantoEngine());

  final transliterator = Transliterator(registry: registry);
}
```

---

## Live Web App Demo & GitHub Pages

Experience Scriptly directly in your browser without installing anything:
👉 **[https://rafipsv.github.io/Scriptly](https://rafipsv.github.io/Scriptly)**

The `example/` folder contains a full-featured, responsive Flutter Web application ready for GitHub Pages:

- **Clean Architecture + BLoC** state management.
- **Material 3 Design** with smooth Dark & Light mode toggling.
- **Dual Capsule Dropdowns** with script badges and language category tags.
- **One-tap swap** button with instant reciprocal conversion.
- Automated CI/CD deployment with GitHub Actions included at `.github/workflows/deploy.yml`.

To run the web app locally:

```bash
# Compile and run via local server:
./build_web.sh
python3 -m http.server 8080 --directory "example/build/web"

# Or run via Flutter dev server with live hot reload:
cd example
flutter run -d chrome
```

---

## Testing & Quality

The package is thoroughly verified with an exhaustive test suite:

```bash
flutter test
```

- **48 Unit Tests** with 100% pass rate.
- Acceptance tests based on Avro and BCP-47 specifications.
- Pairwise connectivity matrix verifying 289 bidirectional conversion combinations.
- Sub-millisecond performance stress tests.
- Zero analysis warnings (`flutter analyze: No issues found!`).

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
