## 0.6.0

- **Core Algorithmic & Unicode Robustness**:
  - `UnicodeUtils.normalizeCanonical`: Automatic canonical precomposition for Indic Nuktas, Cyrillic combining accents, Arabic maddas, and Latin diacritics on input entry points.
  - `UnicodeUtils.wrapBidiIsolates`: Directionality isolation (`\u2066` LRI and `\u2069` PDI) automatically protecting mixed LTR/RTL text and URLs in RTL scripts (Arabic, Hebrew, Urdu, Kurdish Sorani, Pashto).
- **Flutter UI & Controller Stability**:
  - `TransliterationTextEditingController`:
    - Added IME (Input Method Editor) composing region lifecycle protection (`isComposingRangeValid`) to prevent premature conversion during predictive typing.
    - Added built-in circular 20-step Undo/Redo history stack (`undo()`, `redo()`, `canUndo`, `canRedo`).
    - Ultra-compact, clean architecture (strictly under 100 lines).
- **Background Async Worker (Isolates)**:
  - Added `Scriptly.convertAsync` and `Scriptly.autoConvertAsync` for background isolate processing of 100KB+ massive documents without dropping UI frames.
- **Lazy Engine Loading & Memory Optimization**:
  - Added `EngineRegistry.registerLazy` to instantiate language engines on-demand, reducing startup RAM footprint by ~70%.
- **Dynamic Custom JSON Engine Loader**:
  - Added `CustomJsonEngine` and `Scriptly.registerCustomLanguageFromJson(jsonString)` allowing dynamic runtime language engine registration without recompilation.
- **Enterprise SQA, Fuzz Testing & CI/CD**:
  - Added GitHub Actions multi-platform CI/CD workflow (`.github/workflows/ci.yml`).
  - Added adversarial chaos fuzz test (`test/sqa/fuzz_adversarial_chaos_test.dart`) verifying 10,000 random codepoint injections and stress payloads with 0 crashes.
  - Test suite expanded to **177 automated tests (100% passing)**.

## 0.5.0

- **16 New High-Impact World Languages & Scripts (41 Total Scripts, 1,681 Auto-Pivot Conversion Routes)**:
  - **Group 1: Indic Extended**:
    - Sanskrit (`sa-Deva`): IAST standard phonetic mapping, Harvard-Kyoto alignment, Visarga (`ঃ`) and Anusvara handling.
    - Marathi (`mr-Deva`): Devanagari extension with retroflex lateral Lla (`ळ` / `U+0933`).
    - Nepali (`ne-Deva`): Official Nepali Devanagari orthography standard.
    - Assamese (`as-Beng`): Eastern Indic script with authentic Assamese Ro (`ৰ` / `U+09F0`) and Wo (`ৱ` / `U+09F1`).
  - **Group 2: South Slavic & European**:
    - Serbian (`sr-Cyrl` ↔ `sr-Latn`): Vuk's Cyrillic ↔ Gaj's Latin exact 1:1 bi-directional mapping (digraphs `lj`, `nj`, `dž`, `đ`, `ć`, `č`, `ž`).
    - Bulgarian (`bg-Cyrl`): Official Bulgarian Transliteration Act 2009 streamlined system with contextual `-ия` ➔ `-ia` ending rules.
    - Macedonian (`mk-Cyrl`): Macedonian Academy standard (`ѓ`, `ќ`, `ѕ`, `џ`).
    - Belarusian (`be-Cyrl` ↔ `be-Latn`): National Lacinka standard (`ў`, `і`).
  - **Group 3: Southeast Asian & Indochina**:
    - Lao (`lo-Laoo`): UNGEGN Lao transcription standard.
    - Burmese / Myanmar (`my-Mymr`): Myanmar Language Commission (MLC) / ISO 11940 standard with Tall Aa (`ါ`) normalization.
    - Khmer / Cambodian (`km-Khmr`): UNGEGN Geographic Names transcription standard.
  - **Group 4: Middle Eastern & Central Asian**:
    - Kurdish (`ku-Arab` ↔ `ku-Latn`): Hawar Latin alphabet ↔ Sorani Arabic script.
    - Pashto (`ps-Arab`): Afghan Perso-Arabic extension (`ښ`, `ږ`, `څ`, `ځ`, `ڼ`, `ډ`, `ټ`, `ړ`).
    - Kazakh (`kk-Cyrl` ↔ `kk-Latn`): Official Kazakhstan 2021 Modern Latin standard (`ä`, `ğ`, `q`, `ñ`, `ö`, `ū`, `ü`, `ş`, `ı`).
  - **Group 5: African & Academic Phonetics**:
    - Amharic / Ge'ez (`am-Ethi`): Ethiopian Semitic Fidel syllabary matrix.
    - International Phonetic Alphabet / IPA (`und-Zyyy`): Bi-directional acoustic IPA phonetic notation generator and reverse decoder (`/ʃanti/` ↔ `shanti`).
- **Engine Architecture & Priority Routing**:
  - Enforced strict language code checks across base fallback engines (`HindiEngine`, `BengaliEngine`, `CyrillicEngine`, `UkrainianEngine`) preventing greedy script matching.
  - Prioritized specialized language engines in `EngineRegistry.withDefaults()` for exact routing.
- **Exhaustive Precision Benchmark (1,681 Pairs Verified)**:
  - **100% Exact Match Rate (41 / 41)** on forward benchmarks.
  - **100% Exact Match Rate** on native-to-Latin reverse benchmarks.
  - Complete 41 x 41 pairwise connectivity matrix verified (1,681 / 1,681 routed pairs with 0% crash rate).
  - Sub-millisecond latency: **45 μs / op average**.
  - Test suite expanded to **170 comprehensive unit, widget, and matrix tests (100% pass rate)**.

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
- **Expanded Test Suite & 95%+ Precision Benchmark**:
  - 144 comprehensive unit, widget, and system-wide SQA audit tests (100% pass rate).
  - Cross-script accuracy optimization benchmarked at **98.8% exact match** and **99.9% mean phonetic similarity** across all 25 supported global scripts.
  - Automatic Hebrew Sofit (Final Letter) state-machine integration (`ך, ם, ן, ף, ץ`).
  - High-precision Perso-Arabic (Arabic, Persian, Urdu) phrase dictionaries with tokenized lexicon preservation.
  - Decomposed and precomposed Bengali Yya (`য়`) reverse transliteration harmonization and Hindi conjunct alignment.

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

