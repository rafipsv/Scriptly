## 0.4.0

- **Automatic Script Detection (`ScriptDetector` & `Scriptly.detect`)**:
  - Automatically identifies the source script and language family from raw text with confidence scoring.
  - Added `Scriptly.autoConvert(text, to: targetScript)` for one-liner auto-routed transliteration without manually specifying `from`.
- **Custom Dictionary & Word Overrides (`CustomDictionary`)**:
  - Global registry and per-request `customDictionary` overrides taking highest priority for brand names, acronyms, and specialized terminology.
- **Phonetic Matcher & Soundex (`PhoneticMatcher`)**:
  - Cross-script phonetic similarity scoring (`0.0` to `1.0`) and fuzzy matching (`isMatch`).
  - Standardized 4-character phonetic Soundex generator for native and romanized scripts.
- **Flutter UI Components**:
  - `ScriptlySearchField<T>`: Search native-script collections (e.g. cities, contacts, products) using phonetic queries.
  - `ScriptlySuggestionOverlay`: Real-time floating suggestion overlay displaying candidate pills for `TextField`.
- **CLI Executable (`bin/scriptly.dart`)**:
  - Added command-line binary supporting `convert`, `detect`, `file`, and `list` operations.
- **Pure Dart Core (`package:scriptly/scriptly_core.dart`)**:
  - Clean separation allowing `scriptly` core to run in backend servers, CLI tools, and pure Dart scripts without `dart:ui`.
- **Expanded Test Suite**:
  - 140 comprehensive unit, widget, and system-wide SQA audit tests (100% pass rate).

## 0.3.0

- **8 New High-Impact World Languages & Scripts (25+ Total Scripts, 625 Conversion Routes)**:
  - **South Asian (Indic Brahmic Extension)**:
    - Kannada (`kn-Knda`): Paninian Unicode block alignment (`0x0C80`), ISO 15919 transliteration.
    - Odia (`or-Orya`): Bengali sister script alignment (`0x0B00`), National Odia Romanization.
    - Sinhala (`si-Sinh`): Sri Lankan official script (`0x0D80`), ISO 15919 Pali/Sanskrit mapping.
  - **Southeast Asian Engines**:
    - Vietnamese (`vi-Latn`): Complete rule-based Telex input method (`aa` ➔ `â`, `w` ➔ `ư`, `dd` ➔ `đ`) with multi-position tone marks (`s, f, r, x, j`) and reverse accent normalization.
    - Thai (`th-Thai`): Royal Thai General System (RTGS) transcription with consonant/vowel maps and common conversational vocabulary lookups.
  - **Unique World Script Engines**:
    - Georgian Mkhedruli (`ka-Geor`): National Romanization 2002 standard (33 letters, 1:1 bi-directional character mapping).
    - Armenian (`hy-Armn`): ISO 9985 standard with longest-match forward and reverse romanization.
    - Ukrainian Cyrillic (`uk-Cyrl`): Ukrainian National Standard (Resolution 55) & ISO 9, correctly distinguishing `ґ` (g), `г` (h), `є` (ye), `і` (i), `ї` (yi).
- **Searchable Language Dropdown (Web Example)**:
  - Added full real-time search field in `example` application bottom sheet / picker modal.
  - Instant filtering by language display name, script code, or language family.
- **Exhaustive Real-World Testing**:
  - Added 17 new real-world test cases covering conversational phrases, tone placement, reverse conversions, and auto-pivot matrix across all 25 languages (86 total unit tests, 100% pass rate).

## 0.2.1

- Enhanced example with full programmatic transliteration samples across 5 language families.
- Added copy-pasteable `TransliterationTextEditingController` Flutter TextField integration in `example/lib/main.dart`.
- Optimized changelog layout and version alignment for Pub.dev display.

## 0.2.0

- **Multi-Family Script Expansion**:
  - **South Asian (Indic)**: Universal Indic Engine supporting Gujarati (`gu-Gujr`), Punjabi/Gurmukhi (`pa-Guru`), Tamil (`ta-Taml`), Telugu (`te-Telu`), and Malayalam (`ml-Mlym`).
  - **East Asian**: Japanese Engine (Romaji ↔ Hiragana/Katakana), Korean Engine (Revised Romanization ↔ Hangul Syllables), and Chinese Pinyin Engine (numeric tone conversion to diacritics).
  - **Middle Eastern & West Asian**: Perso-Arabic Engine supporting Persian/Farsi (`fa-Arab`), Arabic (`ar-Arab`), and Urdu (`ur-Arab`), along with Hebrew Engine (`he-Hebr`).
  - **European / Slavic**: Russian Cyrillic Engine (ISO 9 standard) and Greek Engine (ISO 843 standard).
- **Direct Brahmic Bridge**: Zero-latency cross-script alignment between Brahmic scripts (Devanagari, Bengali, Gurmukhi, Gujarati, Tamil, Telugu, Malayalam) using parallel Unicode slot mapping.
- **Auto-Pivot Hub-and-Spoke Routing**: Enables universal Any-to-Any conversion across all 17 supported languages (289 conversion routes) through phonetic Latin bridges.
- **Responsive Flutter Web Application (`example/`)**:
  - Clean Architecture + BLoC (`TransliteratorBloc`, `ThemeCubit`).
  - Material 3 dual capsule card dropdowns with script badges and category tags.
  - Light/Dark theme switching, one-tap swap, and quick sample chips.
  - Custom brand favicon and web manifest for Scriptly.
- **GitHub Pages CI/CD Workflow**: Automated deployment workflow (`.github/workflows/deploy.yml`) and `build_web.sh`.
- **Massive Real-World Test Suite**: 48 comprehensive unit tests including acceptance, cross-script alignment, and 1,000-op stress benchmarks.

## 0.1.0

- Core architecture with `LanguageScript`, `TransliteratorEngine`, and `EngineRegistry`.
- Offline Bengali engine supporting bidirectional conversion:
  - Latin/Banglish phonetic typing to Bengali script.
  - Bengali script to deterministic Latin romanization.
- Support for longest-match phonetic parsing, vowel signs (kar), conjuncts (juktakkhor), hasanta, and modifiers.
- Digit conversion policy (preserve ASCII digits or convert to target script).
- `TransliterationTextEditingController` for real-time Flutter TextField integration.
- Unicode utilities with grapheme clustering and script verification.
- Initial unit test suite covering acceptance criteria, punctuation preservation, and edge cases.

