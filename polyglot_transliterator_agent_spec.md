# Polyglot Transliterator --- Agent Build Specification

> **Purpose:** Build a production-quality, extensible Flutter/Dart
> package for converting text between writing systems (transliteration),
> starting with Bengali ↔ Latin/English-script input. The long-term
> architecture must be capable of supporting many languages and scripts
> without rewriting the core.

## 1. Product vision

Create a reusable Dart package that developers can add to Flutter apps
to convert user-entered text between scripts.

The first release supports:

-   **Latin/Banglish → Bengali script:** `Ami Banglay likhi` →
    `আমি বাংলায় লিখি`
-   **Bengali script → Latin/Roman script:** `আমি বাংলাদেশে থাকি` →
    `Ami Bangladesh-e thaki` (using a documented, deterministic
    romanization scheme)

The package is a **transliteration** tool, not a translation tool: -
Transliteration changes the writing system while preserving
pronunciation as closely as the selected scheme allows. - Translation
changes meaning between languages (for example, `আমি ভালো আছি` →
`I am fine`). Translation is explicitly out of scope for the initial
package. - Do not describe the package as an automatic translator.

The long-term goal is broad world-language and script coverage. Do not
claim that every language is supported until it has a tested
implementation and documented limitations.

## 2. Important product decisions

### 2.1 Package identity

Use a temporary working name such as `polyglot_transliterator`. Before
publishing, check Pub.dev for name availability and select a unique name
if necessary. Keep the Dart package name, repository name, and public
API internally consistent.

### 2.2 Initial language/script pair

Initial release: - Bengali (`bn`) script: Bengali Unicode block. - Latin
(`Latn`) input/output. - Latin → Bengali should provide a **phonetic
typing mode** inspired by familiar Banglish/Avro-style typing. - Bengali
→ Latin should provide a clearly documented romanization mode.

Do not assume Bengali-to-Latin is a perfect inverse of Latin-to-Bengali.
Many Bengali sounds and spelling choices can map to the same Latin
sequence, and phonetic input can be ambiguous. Document this and make
the scheme explicit.

### 2.3 Offline-first

The initial engine must work offline and must not require: - an API
key, - a remote server, - network access, - a paid service, - analytics
or telemetry.

A future optional remote engine may be considered, but it must never be
required for core functionality.

### 2.4 Architecture must scale

Design the core around language/script plugins or registries. Adding a
future language should normally mean adding a new engine/rule set and
tests, not changing the central conversion pipeline.

Use BCP-47 language tags where applicable (for example `bn`, `hi`, `ar`,
`ja`) and ISO 15924 script codes where applicable (for example `Beng`,
`Latn`, `Arab`, `Deva`, `Jpan`). Explain language vs script in the
documentation: one script may be used by multiple languages, and one
language may use multiple scripts.

## 3. Scope

### MVP --- version 0.1.x

Must include: 1. Latin/Banglish → Bengali transliteration. 2. Bengali →
Latin romanization. 3. A small, well-tested public Dart API. 4. Offline
operation. 5. Unicode-safe processing. 6. Unit tests and examples. 7.
Clear documentation of supported rules and limitations. 8. A Flutter
TextField/controller integration only if it can be implemented reliably
without compromising the core engine. Keep the pure Dart engine usable
without Flutter where practical.

Should include: - word-boundary handling, - punctuation and whitespace
preservation, - mixed Bengali/Latin text handling, - digits handling
with configurable policy, - capitalization policy, - configurable
transliteration scheme, - suggestions/ambiguity API where feasible.

Not in MVP: - semantic translation, - speech-to-text or
text-to-speech, - OCR, - automatic language detection across all
languages, - cloud APIs, - keyboard/IME replacement, - claims of
complete world-language coverage.

### Future roadmap

Plan the architecture for, but do not implement prematurely: -
Hindi/Devanagari ↔ Latin, - Arabic ↔ Latin, - Urdu ↔ Latin, - Japanese
kana/kanji romanization, - Korean Hangul ↔ Latin, - Chinese pinyin and
other romanization systems, - other Indic scripts, - additional
language-specific transliteration schemes, - user-defined rules and
custom dictionaries, - candidate suggestions and ranking, -
streaming/incremental conversion for large text, - optional Flutter
widgets and editor integrations.

Each future language/script pair must have its own supported scheme,
tests, documentation, and known-limitations section. Avoid a single
universal rule set: transliteration is language- and scheme-dependent.

## 4. Technical architecture

Use a layered design. Keep the core engine independent of Flutter UI.

Suggested conceptual structure:

``` text
lib/
  polyglot_transliterator.dart       # public exports
  src/
    core/
      transliterator.dart            # main interface
      conversion_request.dart
      conversion_result.dart
      conversion_options.dart
      language_script.dart
      engine_registry.dart
      errors.dart
    engines/
      bengali/
        bengali_engine.dart
        banglish_to_bengali.dart
        bengali_to_latin.dart
        rules/
        dictionary/
    unicode/
      unicode_utils.dart
    widgets/                          # optional Flutter-only integration
      transliteration_text_controller.dart
      transliteration_text_field.dart
example/
test/
  core/
  engines/
  unicode/
  widgets/
```

This is a suggested layout, not a reason to create unnecessary
abstractions. Keep the implementation understandable and maintainable.

### 4.1 Core interface

Design a small API along these lines (names may be improved, but keep
the same capabilities):

``` dart
final transliterator = Transliterator(
  registry: EngineRegistry.withDefaults(),
);

final result = transliterator.convert(
  'Ami Banglay likhi',
  from: const LanguageScript('en', 'Latn'),
  to: const LanguageScript('bn', 'Beng'),
  options: const ConversionOptions(
    mode: ConversionMode.phonetic,
  ),
);

print(result.text); // আমি বাংলায় লিখি
```

Also provide convenience methods for the initial Bengali pair:

``` dart
final bn = BengaliTransliterator();

final bangla = bn.toBengali('Ami Banglay likhi');
final roman = bn.toLatin('আমি বাংলায় লিখি');
```

Expected result types should make it possible to return: - converted
text, - detected/selected scheme, - warnings or unsupported-character
information, - optional alternative candidates in future versions.

Do not throw for ordinary user text merely because it contains
punctuation, emoji, digits, or mixed scripts. Preserve unsupported
content where safe, and expose diagnostics separately.

### 4.2 Engine contract

Each engine should: - declare supported source and target
language/script pairs; - declare the scheme and its version; - validate
options it supports; - preserve whitespace and punctuation unless
explicitly configured otherwise; - return deterministic results for the
same input and options; - avoid global mutable state; - be independently
testable; - document ambiguous mappings and exceptions.

The registry should select an engine based on the requested
language/script pair and scheme. If no engine exists, return a typed,
understandable unsupported-conversion error. Do not silently apply an
unrelated engine.

### 4.3 Rule-based Bengali engine

For MVP, implement a documented, deterministic phonetic transliteration
engine. You may study existing open-source approaches (including
Avro-style phonetic rules) for algorithmic ideas, but: - do not copy
code, rule tables, dictionaries, or assets unless their license
explicitly permits redistribution; - preserve required copyright and
license notices; - record provenance and license for every borrowed
resource; - prefer implementing independently from documented behavior.

The engine should handle: - multi-character patterns before shorter
patterns (longest-match strategy where appropriate); - consonant and
vowel combinations; - inherent vowel behavior; - vowel signs/matras; -
conjunct consonants; - hasanta/virama behavior; - word boundaries and
punctuation; - common Banglish spellings; - context-sensitive rules
where required; - common exceptions and dictionary overrides.

Do not implement this as a naive one-character-to-one-character
replacement map. Bengali orthography requires context-sensitive
processing.

For Bengali → Latin, choose and document a consistent romanization
scheme. Provide examples and explain that multiple valid romanizations
can exist. Do not promise that converting Bengali to Latin and back will
reproduce the exact original spelling.

### 4.4 Unicode requirements

-   Use Dart strings and Unicode-safe iteration; do not assume one
    user-perceived character equals one UTF-16 code unit.
-   Account for combining marks and grapheme clusters where needed.
    Consider the `characters` package if it materially improves
    correctness.
-   Preserve emoji, ZWJ sequences, punctuation, line breaks, and
    whitespace.
-   Do not normalize or strip marks without an explicit, documented
    reason.
-   Test Bengali vowel signs, virama, nukta where relevant, combining
    marks, and mixed-script text.
-   Avoid splitting a grapheme cluster during cursor operations in any
    TextField integration.

## 5. Flutter TextField integration

The pure conversion API is the priority. If adding a Flutter
integration, make it optional and ergonomic.

Possible usage:

``` dart
TransliterationTextField(
  from: const LanguageScript('en', 'Latn'),
  to: const LanguageScript('bn', 'Beng'),
  decoration: const InputDecoration(
    labelText: 'Write in Banglish',
  ),
)
```

Requirements: - support normal `TextField` behavior and standard
decoration; - preserve selection and cursor position after conversion; -
support composing/IME text input safely; - do not repeatedly convert
text in a loop; - do not corrupt paste operations, undo/redo, selection,
or autocorrect; - provide a way to disable conversion temporarily; -
allow users to accept or reject a candidate before replacing typed text,
if live replacement would be disruptive; - avoid changing the user's
text unexpectedly.

If reliable cursor/IME behavior cannot be achieved in the MVP, ship the
core Dart API first and defer the widget. Do not advertise a widget that
breaks normal text editing.

## 6. Configuration and behavior

Provide typed options rather than many unrelated boolean flags. Consider
options for: - conversion mode/scheme; - digit preservation or digit
conversion; - preserve existing Bengali text; - preserve Latin words or
convert all eligible input; - punctuation and whitespace preservation; -
strict vs permissive handling; - candidate/suggestion count (future); -
custom dictionary/rules (future).

Defaults must be safe and predictable. Document all defaults.

For live typing, consider a two-stage workflow: 1. Keep the raw typed
token while the user is composing it. 2. Commit conversion on a clear
boundary (space, punctuation, explicit action) or after candidate
acceptance.

Do not force conversion after every keystroke if it causes flicker,
cursor jumps, or prevents users from typing ambiguous sequences.

## 7. Quality requirements

The package must be: - null-safe; - soundly typed; - formatted with
`dart format`; - free of avoidable analyzer warnings; - covered by
meaningful tests; - documented with runnable examples; - deterministic
and offline; - reasonably performant for normal mobile text input; -
compatible with a clearly stated Dart/Flutter SDK range.

Avoid unnecessary dependencies. Every dependency must have a reason and
be compatible with the package's license and supported SDK range.

## 8. Testing plan

Create tests before considering the MVP complete.

### Core tests

-   supported engine lookup;
-   unsupported pair error;
-   options validation;
-   deterministic output;
-   empty string;
-   null is not accepted where API requires non-null input.

### Bengali → Latin tests

Include a documented set of examples for: - simple words; - sentences; -
vowel signs; - conjunct consonants; - punctuation; - numbers; -
whitespace and line breaks; - mixed Bengali and Latin; - emoji; -
uncommon or ambiguous spellings.

### Latin/Banglish → Bengali tests

Include examples such as: - `Dhaka` → `ঢাকা` - `Ami` → `আমি` -
`Bangladesh` → `বাংলাদেশ` - `Bhalo` → `ভালো` - `Kemon acho` → `কেমন আছো`

These are acceptance examples, not a complete rule specification. Expand
the corpus with independently checked Bengali examples. Make tests
reflect the documented scheme; do not silently alter expected output
just to make a failing implementation pass.

### Property and regression tests

-   punctuation and whitespace preservation;
-   unsupported characters preserved;
-   no accidental loss of Unicode marks;
-   stable repeated conversions;
-   large input does not cause pathological slowdown;
-   cursor/selection behavior if a widget is included.

Keep a regression corpus for every bug fixed.

## 9. Documentation requirements

Create a useful `README.md` containing: 1. What the package does. 2.
Explicit explanation of transliteration vs translation. 3. Supported
conversions and schemes. 4. Installation instructions. 5. Basic Dart
usage. 6. Flutter usage, only if widget integration ships. 7.
Configuration examples. 8. Input/output examples. 9. Known limitations
and ambiguity. 10. Offline/privacy statement. 11. Roadmap for future
language support. 12. Contribution guide link or instructions. 13.
License.

Also create: - `CHANGELOG.md`; - `LICENSE` (choose a permissive license
such as MIT only if the project owner agrees and all included resources
are compatible); - `CONTRIBUTING.md`; - `example/`; - tests; - package
metadata in `pubspec.yaml`.

Never claim support for a language that is only listed in the roadmap.

## 10. Pub.dev publishing readiness

Before publishing: - check package-name availability on Pub.dev; -
choose a clear description and relevant topics; - set a valid SDK
constraint; - ensure `pubspec.yaml` has correct name, version,
description, repository, issue tracker, documentation, and license
metadata as applicable; - run `dart format .`; - run `flutter analyze`
(for Flutter package) or `dart analyze` (for pure Dart package); - run
`flutter test` / `dart test`; - run `dart pub publish --dry-run`; - fix
all warnings that can reasonably be fixed; - inspect the package
contents to ensure no secrets, generated clutter, private files, or
irrelevant assets are included; - verify README examples compile; -
verify all third-party licenses and attributions; - use semantic
versioning and maintain a changelog.

Do not publish automatically. Prepare the package and report the exact
commands and any remaining manual steps. The owner must review and
authorize the actual publish.

## 11. Agent execution workflow

Work in small, reviewable phases. Do not attempt to build every future
language in one pass.

### Phase 0 --- research and design

1.  Inspect current Pub.dev packages and relevant open-source
    transliteration projects.
2.  Review licenses before using any code or data.
3.  Compare behavior and identify gaps.
4.  Write a short architecture decision record (ADR) covering package
    structure, Bengali schemes, dependencies, and API.
5.  Confirm package name availability before finalizing the name.

### Phase 1 --- core foundation

1.  Create package skeleton.
2.  Implement language/script identifiers, request/options/result
    models, engine interface, registry, and typed errors.
3.  Add core tests.
4.  Ensure core can be used without Flutter UI dependencies if feasible.

### Phase 2 --- Bengali MVP engine

1.  Implement Latin/Banglish → Bengali.
2.  Implement Bengali → Latin using the documented scheme.
3.  Build a representative test corpus.
4.  Add edge-case handling and regression tests.
5.  Document ambiguous cases and known limitations.

### Phase 3 --- Flutter integration

1.  Prototype a TextEditingController or TextField wrapper.
2.  Test selection, composing ranges, paste, multiline, undo/redo, and
    IME behavior.
3.  Ship only if it behaves like a normal Flutter text input.

### Phase 4 --- release preparation

1.  Finish README, changelog, license, examples, and contribution docs.
2.  Run formatting, analyzer, tests, and Pub.dev dry-run.
3.  Review package contents and licensing.
4.  Produce a release checklist and wait for owner approval.

### Phase 5 --- future language expansion

For each new language/script: 1. define language and script tags; 2.
select a recognized transliteration scheme; 3. document directionality
and ambiguity; 4. implement an isolated engine; 5. add a curated test
corpus and regression tests; 6. document limitations; 7. add it to the
support matrix only after tests pass.

## 12. Acceptance criteria for the first release

The MVP is ready only when: - \[ \] Latin/Banglish → Bengali works
offline. - \[ \] Bengali → Latin works offline using a documented
scheme. - \[ \] The package clearly says it performs transliteration,
not semantic translation. - \[ \] Core API is reusable and not coupled
to a specific widget. - \[ \] Bengali engine is isolated behind a stable
engine contract. - \[ \] Unicode, punctuation, whitespace, emoji, and
mixed-script tests pass. - \[ \] The documented examples match actual
tested behavior. - \[ \] No unlicensed copied code or dictionary data is
included. - \[ \] Analyzer and tests pass. - \[ \] Pub.dev dry-run
succeeds. - \[ \] README states current support accurately and
distinguishes roadmap languages from implemented languages. - \[ \]
Actual publishing waits for the owner's approval.

## 13. Final instruction to the coding agent

Build the **smallest reliable first release** while preserving the
extensible architecture. Prioritize correctness, clear APIs, Unicode
safety, documentation, tests, and licensing over a large feature count.

Do not fake world-language support, do not use a universal character
replacement table, do not introduce a required cloud dependency, and do
not publish without approval.

At the end, report: - package name and structure; - implemented
features; - supported language/script directions and schemes; -
test/analyzer/publish-dry-run results; - dependencies and why they are
needed; - third-party code/data and license status; - known
limitations; - exact next steps for the owner.
