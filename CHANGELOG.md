# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-11-11

### Added
- **Multi-Family Script Expansion**:
  - **South Asian (Indic)**: Universal Indic Engine supporting Gujarati (`gu-Gujr`), Punjabi/Gurmukhi (`pa-Guru`), Tamil (`ta-Taml`), Telugu (`te-Telu`), and Malayalam (`ml-Mlym`).
  - **East Asian**: Japanese Engine (Romaji ↔ Hiragana/Katakana), Korean Engine (Revised Romanization ↔ Hangul Syllables), and Chinese Pinyin Engine (numeric tone conversion to diacritics).
  - **Middle Eastern & West Asian**: Perso-Arabic Engine supporting Persian/Farsi (`fa-Arab`), Arabic (`ar-Arab`), and Urdu (`ur-Arab`), along with Hebrew Engine (`he-Hebr`).
  - **European / Slavic**: Russian Cyrillic Engine (ISO 9 standard) and Greek Engine (ISO 843 standard).
- **Direct Brahmic Bridge**: Zero-latency cross-script alignment between Brahmic scripts (Devanagari, Bengali, Gurmukhi, Gujarati, Tamil, Telugu, Malayalam) using parallel Unicode slot mapping.
- **Auto-Pivot Hub-and-Spoke Routing**: Enables universal Any-to-Any conversion across all 17 supported languages ($17 \times 17 = 289$ conversion routes) through phonetic Latin bridges.
- **Responsive Flutter Web Application (`example/`)**:
  - Clean Architecture + BLoC (`TransliteratorBloc`, `ThemeCubit`).
  - Material 3 dual capsule card dropdowns with script badges and category tags.
  - Light/Dark theme switching, one-tap swap, and quick sample chips.
  - Custom brand favicon and web manifest for Scriptly.
- **GitHub Pages CI/CD Workflow**: Automated deployment workflow (`.github/workflows/deploy.yml`) and `build_web.sh`.
- **Massive Real-World Test Suite**: 48 comprehensive unit tests including acceptance, cross-script alignment, and 1,000-op stress benchmarks.

## [0.1.0] - 2026-11-11

### Added
- Core architecture with `LanguageScript`, `TransliteratorEngine`, and `EngineRegistry`.
- Offline Bengali engine supporting bidirectional conversion:
  - Latin/Banglish phonetic typing to Bengali script.
  - Bengali script to deterministic Latin romanization.
- Support for longest-match phonetic parsing, vowel signs (kar), conjuncts (juktakkhor), hasanta, and modifiers.
- Digit conversion policy (preserve ASCII digits or convert to target script).
- `TransliterationTextEditingController` for real-time Flutter TextField integration.
- Unicode utilities with grapheme clustering and script verification.
- Initial unit test suite covering acceptance criteria, punctuation preservation, and edge cases.
