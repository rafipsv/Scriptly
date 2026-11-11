# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-11-11

### Added
- Auto-Pivot Routing in `Transliterator`: automatically bridges any two languages via Latin when a direct engine is not available.
- Hindi / Devanagari Engine (`Hinglish ↔ Devanagari`).
- Perso-Arabic Engine supporting Arabic (`Arabizi ↔ Arabic script`), Urdu (`Roman Urdu ↔ Urdu script`), and direct Arabic ↔ Urdu script harmonizer.
- Indic Bridge Engine: Direct zero-latency cross-script transliteration between Devanagari and Bengali.
- Responsive Google Translate-style Flutter Web application (`example/`) with mobile/desktop support.
- GitHub Pages automated deployment workflow (`.github/workflows/deploy.yml`) and `build_web.sh`.

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
- Unit test suite covering acceptance criteria, punctuation preservation, and edge cases.
